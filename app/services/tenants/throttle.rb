module Tenants
  class Throttle
    QUOTA_LIMIT = 3

    TENANT_BLOCKED = 'tenant_blocked'.freeze
    MISSING_API_KEY = 'missing_api_key'.freeze
    INVALID_API_KEY = 'invalid_api_key'.freeze

    TENANT_COUNT_KEY_PREFIX = 'daily_tenant_count_'.freeze
    INITIALIZED_TENANT_COUNT_KEY_PREFIX = 'daily_tenant_count_initialized_'.freeze
    UNBLOCKING_TENANT_DATE_KEY_PREFIX = 'daily_tenant_unblocking_datetime_'.freeze

    def initialize(api_key)
      @tenant = Tenant.find_by(api_key: api_key)
    end

    def track
      @tenant.track_request

      initialize_daily_tracking unless daily_tracking_initialized?

      track_daily_request
    end

    def blocked?
      daily_tracking_initialized? && quota_limit_reached? && must_wait?
    end

    def daily_count
      Rails.cache.read("#{TENANT_COUNT_KEY_PREFIX}#{@tenant.id}")
    end

    private

    def daily_tracking_initialized?
      Rails.cache.read("#{INITIALIZED_TENANT_COUNT_KEY_PREFIX}#{@tenant.id}")
    end

    def initialize_daily_tracking
      Rails.cache.write("#{TENANT_COUNT_KEY_PREFIX}#{@tenant.id}", 0)
      Rails.cache.write(
        "#{INITIALIZED_TENANT_COUNT_KEY_PREFIX}#{@tenant.id}",
        true,
        expires_in: 1.day
      )
    end

    def track_daily_request
      Rails.cache.write(
        "#{TENANT_COUNT_KEY_PREFIX}#{@tenant.id}",
        daily_count + 1
      )

      block_tenant if quota_limit_reached?
    end

    def block_tenant
      Rails.cache.write(
        "#{UNBLOCKING_TENANT_DATE_KEY_PREFIX}#{@tenant.id}",
        Time.now + 10.seconds
      )
    end

    def unblocking_date
      Rails.cache.read("#{UNBLOCKING_TENANT_DATE_KEY_PREFIX}#{@tenant.id}")
    end

    def quota_limit_reached?
      daily_count >= QUOTA_LIMIT
    end

    def must_wait?
      unblocking_date && Time.now < unblocking_date
    end
  end
end
