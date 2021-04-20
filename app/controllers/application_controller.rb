class ApplicationController < ActionController::Base
  before_action :validate_tenant

  private

  def validate_tenant
    if request.env[Tenants::Throttle::MISSING_API_KEY]
      render json: { message: 'Missing API KEY' }, status: :bad_request
      return
    end

    if request.env[Tenants::Throttle::INVALID_API_KEY]
      render json: { message: 'Invalid API KEY' }, status: :unauthorized
      return
    end

    if request.env[Tenants::Throttle::TENANT_BLOCKED]
      render json: { message: 'Quota limit reached' }, status: :too_many_requests
    end

    @tenant_count = Tenants::Throttle.new(params[:api_key]).daily_count
  end
end
