class Vehicle < ApplicationRecord
  validates :nickname, presence: true, uniqueness: true
  validates :vin_number, uniqueness: true, allow_blank: true
  validates :license_plate, uniqueness: true, allow_blank: true

  # Additional validations can be added as needed
  validates :make, :model, :year, presence: true

  # Associations can be defined here if needed
end