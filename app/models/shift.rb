class Shift < ApplicationRecord
  belongs_to :driver
  has_one :vehicle

  validates :vehicle_id, presence: true
  validates :driver_id, presence: true

  validates :bankroll_borrowed, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Additional validations and methods can be added here as needed
end