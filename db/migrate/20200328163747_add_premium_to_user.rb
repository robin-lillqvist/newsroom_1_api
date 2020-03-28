# frozen_string_literal: true

class AddPremiumToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :premium_user, :boolean
  end
end
