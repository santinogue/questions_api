class QuestionsController < ApplicationController
  def index
    render json: QuestionBlueprint.render(Question.shareable), status: :ok
  end
end
