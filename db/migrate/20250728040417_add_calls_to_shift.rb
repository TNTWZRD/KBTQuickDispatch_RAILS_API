class AddCallsToShift < ActiveRecord::Migration[8.0]
  def change
    add_reference :shifts, :calls, foreign_key: true
  end
end
