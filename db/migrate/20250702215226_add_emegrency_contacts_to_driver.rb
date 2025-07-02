class AddEmegrencyContactsToDriver < ActiveRecord::Migration[8.0]
  def change
    add_column :drivers, :emergency_contact_names, :string
    add_column :drivers, :emergency_contact_numbers, :string
  end
end
