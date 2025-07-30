class Shift < ApplicationRecord
  belongs_to :driver
  has_one :vehicle
  has_many :calls


  after_create :broadcast_create
  after_update :broadcast_update

  validates :vehicle_id, presence: true
  validates :driver_id, presence: true

  validates :bankroll_borrowed, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true


  private

  def broadcast_create
    ActionCable.server.broadcast('shifts_channel', { action: 'new_shift', shift: self.as_json })
  end

  def broadcast_update
    ActionCable.server.broadcast('shifts_channel', { action: 'update_shift', shift: self.as_json })
  end

  
  # Additional validations and methods can be added here as needed
end