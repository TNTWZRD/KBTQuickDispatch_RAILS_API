class CreateLocationHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :location_histories do |t|
      t.timestamps
      t.references :user, null: true, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.float :altitude
      t.float :heading
      t.float :speed
      t.boolean :is_mobile, default: false
    end
  end
end
