class CreateShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :shifts do |t|
      t.timestamps
      t.references :driver, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.datetime :end_time
      t.boolean :status, null: false, default: 1
      t.datetime :cleared_at
      t.datetime :last_cleared_at
      t.decimal :bankroll_borrowed, precision: 10, scale: 2
      t.boolean :reports_enabled, null: false, default: 1
      
    end
  end
end
