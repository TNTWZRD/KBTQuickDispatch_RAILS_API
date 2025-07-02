class CreateDrivers < ActiveRecord::Migration[8.0]
  def change
    create_table :drivers do |t|
      t.timestamps
      t.string :name, null: true
      t.integer :status, default: 1
      t.string :reg_code
      t.bigint :user_id, null: true, default: nil
      t.boolean :reports_enabled, default: true
      t.string :phone_number, null: false
      t.index ["name"], name: "index_drivers_on_name", unique: true
      t.index ["user_id"], name: "index_drivers_on_user_id"
    end
  end
end
