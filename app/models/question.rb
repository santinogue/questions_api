class Question < ApplicationRecord
  belongs_to :user
  has_many   :answers

  scope :shareable, -> { where(share: true) }

  validates_presence_of :title
end
