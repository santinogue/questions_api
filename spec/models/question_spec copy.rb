require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { create(:question) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an user' do
      expect(subject).to belong_to(:user).without_validating_presence
    end

    it 'has many answers' do
      expect(subject).to have_many(:answers)
    end
  end

  describe 'scopes' do
    let!(:not_shared) { create(:question, share: false) }

    it 'returns shareable questions' do
      expect(described_class.shareable).to include(subject)
      expect(described_class.shareable).to_not include(not_shared)
    end
  end
end
