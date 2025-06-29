class Api::V1::UsersController < Api::V1::BaseController
  include RackSessionFix
  before_action :authenticate_user!

  def getDrivers
    respond_to: :json
    drivers = User.where(role: 'driver').order(created_at: :desc)
    render json: drivers, status: :ok
  end

end