class AnswerBlueprint < Blueprinter::Base
  identifier :id

  field :user_id, name: :provider

  fields :body, :created_at, :updated_at
end
