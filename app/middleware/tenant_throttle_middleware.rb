class TenantThrottleMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env[Tenants::Throttle::MISSING_API_KEY] || env[Tenants::Throttle::INVALID_API_KEY]
      return @app.call(env)
    end

    request = Rack::Request.new(env)
    api_key = request.params['api_key']

    tenant_throttle = Tenants::Throttle.new(api_key)

    if tenant_throttle.blocked?
      Rails.logger.info 'Tenant is blocked'
      env[Tenants::Throttle::TENANT_BLOCKED] = true
    else
      tenant_throttle.track
    end

    @app.call(env)
  end
end
