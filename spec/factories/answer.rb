FactoryBot.define do
  factory :answer do
    user
    question
    body { 'Answer' }
    created_at { 1.month.ago }
    updated_at { 1.month.ago }
  end
end
