class AddOnlineStatusToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :online_status, :string
  end
end
