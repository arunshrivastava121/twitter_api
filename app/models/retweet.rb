class Retweet < ApplicationRecord
  belongs_to :post

  validates :user_id, presence: true
end
