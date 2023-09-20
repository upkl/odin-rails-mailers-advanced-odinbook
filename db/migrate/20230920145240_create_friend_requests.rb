class CreateFriendRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :friend_requests do |t|
      t.integer :status, null: false, default: 0
      t.bigint :sender_id, null: false
      t.bigint :receiver_id, null: false

      t.timestamps
    end

    add_foreign_key :friend_requests, :users, column: :sender_id
    add_foreign_key :friend_requests, :users, column: :receiver_id
    add_index :friend_requests, :sender_id
    add_index :friend_requests, :receiver_id
    add_index :friend_requests, %i[sender_id receiver_id], unique: true
  end
end
