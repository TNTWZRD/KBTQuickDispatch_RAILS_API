class Driver < ApplicationRecord

  has_many :shifts, dependent: :destroy
  belongs_to :user, optional: true, dependent: :destroy

  validates :name, presence: false, uniqueness: { case_sensitive: false }
  validates :phone_number, presence: false, uniqueness: { case_sensitive: false }
  validates :user_id, uniqueness: true, allow_nil: true

end