# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user
  has_many :likes
  has_many :comments

  def sorted_comments
    comments.includes(:user).sort_by(&:created_at).reverse
  end

  def liked_by(user_id)
    likes.find_by(user_id:)
  end
end
