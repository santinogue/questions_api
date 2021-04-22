class WelcomeController < ApplicationController
  skip_before_action :validate_tenant

  def index
    @questions_count = Question.count
    @answers_count = Answer.count
    @users_count = User.count
    @tenants_api_requets = Tenant.all.sum(:api_requests)
  end
end
