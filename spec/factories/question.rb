FactoryBot.define do
  factory :question do
    user
    share { true }
    title { 'Question' }
    created_at { 1.month.ago }
    updated_at { 1.month.ago }

    transient do
      answers_count { 5 }
    end

    after(:create) do |question, evaluator|
      create_list(:answer, evaluator.answers_count, question: question)
      question.reload
    end
  end
end
