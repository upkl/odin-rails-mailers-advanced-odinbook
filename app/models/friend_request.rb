class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :status, presence: true
  validates :status, comparison: { greater_than_or_equal_to: 0, less_than: 3 }
end
