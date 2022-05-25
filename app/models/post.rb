class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  belongs_to :user

  validates :text, presence: true
end
