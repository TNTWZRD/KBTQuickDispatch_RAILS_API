class AddPreviousVehiclesToShift < ActiveRecord::Migration[8.0]
  def change
    add_column :shifts, :previous_vehicles, :string, :null => true
    #Ex:- :null => false
  end
end
