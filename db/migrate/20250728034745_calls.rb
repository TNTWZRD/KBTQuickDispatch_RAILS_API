class Calls < ActiveRecord::Migration[8.0]
  def change
    create_table :calls do |t|
      t.timestamps
      t.references :shift, null: true, foreign_key: true
      t.references :vehicle, null: true, foreign_key: true

      t.string :status, null: false, default: 'pending'
      
      t.datetime :scheduled_pickup_time
      t.datetime :picked_up_at_time
      t.datetime :dropped_off_at_time
      
      t.string :pickup_address, null: false
      t.string :dropoff_address

      t.integer :modifers, default: 0, null: false
      t.integer :fare, default: 0, null: false
      t.integer :distance, default: 0, null: false
      t.integer :duration, default: 0, null: false
      
      t.string :phone_number
      t.string :notes
      t.integer :passenger_count, default: 1, null: false

      t.index [:shift_id, :vehicle_id], unique: true
    end

  end
end
