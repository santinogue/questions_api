require 'rails_helper'

RSpec.describe Tenant, type: :model do
  subject { create(:tenant) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'generate_api_key' do
    let(:tenant_whith_no_api_key) { create(:tenant, api_key: nil) }

    it 'generates an api key before creating' do
      expect(tenant_whith_no_api_key.api_key).not_to be_empty
    end
  end

  describe 'track_request' do
    it 'increases api request when called' do
      api_requests = subject.api_requests
      subject.track_request
      expect(subject.api_requests).to be(api_requests + 1)
    end
  end
end
