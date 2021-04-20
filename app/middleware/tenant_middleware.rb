class TenantMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    api_key = request.params['api_key']

    unless api_key
      env[Tenants::Throttle::MISSING_API_KEY] = true
      return @app.call(env)
    end

    tenant = Tenant.find_by(api_key: api_key)

    env[Tenants::Throttle::INVALID_API_KEY] = true unless tenant

    @app.call(env)
  end
end
