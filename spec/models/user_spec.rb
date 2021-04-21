require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many questions' do
      expect(subject).to have_many(:questions)
    end

    it 'has many answers' do
      expect(subject).to have_many(:answers)
    end
  end
end
