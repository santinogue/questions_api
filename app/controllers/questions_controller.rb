class QuestionsController < ApplicationController
  def index
    render json: QuestionBlueprint.render(
                  Question.shareable,
                  root: :questions,
                  meta: { tenant_requests: @tenant_count }
                ),
           status: :ok
  end
end
