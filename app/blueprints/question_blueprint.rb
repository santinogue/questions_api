class QuestionBlueprint < Blueprinter::Base
  identifier :id

  field :user_id, name: :asker

  fields :title, :created_at, :updated_at

  association :answers, blueprint: AnswerBlueprint
end
