# frozen_string_literal: true

class AddProfileInformationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :city, :string
    add_column :users, :dish, :string
  end
end
