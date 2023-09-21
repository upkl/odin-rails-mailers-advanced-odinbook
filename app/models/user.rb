# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :friend_requests_sent, foreign_key: 'sender_id', class_name: 'FriendRequest'
  has_many :friend_requests_received, foreign_key: 'receiver_id', class_name: 'FriendRequest'
  has_many :posts
  has_many :likes
  has_many :comments

  include Gravtastic
  gravtastic secure: true

  def friends
    result = friend_requests_sent.accepted.map(&:receiver)
    result.union(friend_requests_received.accepted.map(&:sender))
  end

  def friend_ids
    result = friend_requests_sent.accepted.map(&:receiver_id)
    result.union(friend_requests_received.accepted.map(&:sender_id))
  end
end
