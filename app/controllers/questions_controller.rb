class QuestionsController < ApplicationController
  def index
    render json: QuestionBlueprint.render(
      Question.shareable,
      root: :questions
    ), status: :ok
  end
end
