require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  context 'index action' do
    let(:tenant) { create(:tenant) }

    context 'with valid api key' do
      before do
        create(:question)
        create(:question, share: false)
      end

      it 'responds successfully' do
        get :index, params: { api_key: tenant.api_key }
        expect(response.status).to eq(200)
      end

      it 'respond with the shareable answers' do
        get :index, params: { api_key: tenant.api_key }

        expected_response = QuestionBlueprint.render(
          Question.shareable,
          root: :questions
        )

        expect(response.body).to eq(expected_response)
      end
    end

    context 'with invalid api key' do
      before do
        request.env[Tenants::Throttle::INVALID_API_KEY] = true
      end

      it 'responds unauthorized' do
        get :index
        expect(response.status).to eq(401)
      end
    end

    context 'with no api key' do
      before do
        request.env[Tenants::Throttle::MISSING_API_KEY] = true
      end

      it 'responds bad request' do
        get :index
        expect(response.status).to eq(400)
      end
    end

    context 'when quota limit reached' do
      before do
        request.env[Tenants::Throttle::TENANT_BLOCKED] = true
      end

      it 'responds too many requests' do
        get :index, params: { api_key: tenant.api_key }
        expect(response.status).to eq(429)
      end
    end
  end
end
