class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :sub_comments, class_name: "Comment", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Comment", optional: true

  validates :body, :username, presence: true
end
