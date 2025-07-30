class AddCancelTimeToCalls < ActiveRecord::Migration[8.0]
  def change
    add_column :calls, :canceled_at_time, :datetime, null: true
  end
end
