class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :jwt_authenticatable, jwt_revocation_strategy: self,
         authentication_keys: [:login]

  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates :email, presence: :true, uniqueness: { case_sensitive: false }
  validates :phone_number, uniqueness: { case_sensitive: false }, allow_blank: true

  has_one :driver, dependent: :destroy

  ROLE_VAL = {user: 0, driver: 1, dispatcher: 2, manager: 4, owner: 8, admin: 16}.freeze

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def has_role?(role)
    if role.is_a?(Symbol)
      return self.has_role?(ROLE_VAL[role]) if ROLE_VAL[role]
      return false
    end
    if role.is_a?(String)
      return self.has_role?(ROLE_VAL[role.to_sym]) if ROLE_VAL[role.to_sym]
      return false
    end
    if role.is_a?(Integer)
      return (self.role.to_i & role.to_i) == role
    end
  end

  def set_role(role, value)
    if role.is_a?(Symbol)
      role = ROLE_VAL[role]
    elsif role.is_a?(String)
      role = ROLE_VAL[role.to_sym]
    elsif role.is_a?(Array)
      role.each do |r|
        self.set_role(r, value)
      end
      return
    end
    self.role = self.role.to_i - role.to_i if self.has_role?(role) && value == false
    self.role = self.role.to_i + role.to_i if !self.has_role?(role) && value == true
  end

  def get_roles
    roles = []
    ROLE_VAL.each do |role, value|
      roles << role if self.has_role?(value)
    end
    roles
  end

  def is_driver?
    self.has_role?(:driver)
  end
  def is_dispatcher?
    self.has_role?(:dispatcher)
  end
  def is_manager?
    self.has_role?(:manager)
  end
  def is_owner?
    self.has_role?(:owner)
  end
  def is_admin?
    self.has_role?(:admin)
  end

end
