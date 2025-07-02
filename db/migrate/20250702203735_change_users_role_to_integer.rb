class ChangeUsersRoleToInteger < ActiveRecord::Migration[8.0]
  def change
    # Change the role column from string to integer
    change_column :users, :role, :integer, default: 0
  end
end
