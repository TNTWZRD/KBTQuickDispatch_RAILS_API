class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :username, :created_at, :phone_number, :status, :darkmode, :online_status, :role

  attribute :roles do |user|
    user.get_roles.map(&:to_s)
  end
end
