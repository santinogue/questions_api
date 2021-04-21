require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject { create(:answer) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a body' do
      subject.body = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an user' do
      expect(subject).to belong_to(:user).without_validating_presence
    end

    it 'belongs to question' do
      expect(subject).to belong_to(:question).without_validating_presence
    end
  end
end
