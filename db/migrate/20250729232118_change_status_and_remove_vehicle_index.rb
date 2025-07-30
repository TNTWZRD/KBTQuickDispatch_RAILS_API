class ChangeStatusAndRemoveVehicleIndex < ActiveRecord::Migration[8.0]
  def change

    remove_foreign_key :calls, :vehicles

    remove_index :calls, column: :vehicle_id
    remove_index :calls, column: [:shift_id, :vehicle_id]

    add_foreign_key :calls, :vehicles
    
    change_column :calls, :status, :string, default: 'waiting', null: false
  end
end
