class AddIpToLocationHistory < ActiveRecord::Migration[8.0]
  def change
    add_column :location_histories, :ipaddress, :string
  end
end
