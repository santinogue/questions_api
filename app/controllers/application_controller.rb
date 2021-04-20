class ApplicationController < ActionController::Base
  before_action :validate_tenant

  private

  def validate_tenant
    unless params[:api_key]
      render json: { message: 'Missing API KEY' }, status: :bad_request
      return
    end

    @tenant = Tenant.find_by(api_key: params[:api_key])
    @tenant.track_request

    unless @tenant
      render json: { message: 'Invalid API KEY' }, status: :unauthorized
    end
  end
end
