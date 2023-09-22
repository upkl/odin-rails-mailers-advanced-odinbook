# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[github]

  validates :name, presence: true

  after_commit :send_welcome_email, on: :create

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

  def send_welcome_email
    UserMailer.with(user: self).welcome_email.deliver_later
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      data = session['devise.facebook_data']
      user.email = data['email'] if data && session['devise.facebook_data']['extra']['raw_info'] && user.email.blank?
    end
  end
end
