class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.string :nickname, null: false
      t.string :vin_number
      t.string :license_plate
      t.string :make
      t.string :model
      t.string :year
      t.string :color
      t.string :description
      t.string :short_notes
      t.index :nickname, unique: true
      t.index :vin_number, unique: true
      t.index :license_plate, unique: true
      t.integer :status, default: 1
      t.timestamps
    end
  end
end
