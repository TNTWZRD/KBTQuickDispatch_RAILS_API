class Api::V1::DriversController < Api::V1::BaseController
  include RackSessionFix
  before_action :authenticate_user!

  def getDrivers
    drivers = User.where("role & ? = ?", User.roles[:driver], User.roles[:driver])
    render json: drivers, status: :ok
  end

end