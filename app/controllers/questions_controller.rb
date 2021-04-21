class QuestionsController < ApplicationController
  def index
    render json: QuestionBlueprint.render(
      Question.shareable,
      root: :questions,
      meta: { tenant_requests_count: @tenant_requests_count }
    ), status: :ok
  end
end
