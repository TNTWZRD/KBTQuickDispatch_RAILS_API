class Api::V1::DriversController < Api::V1::BaseController
  include RackSessionFix
  before_action :authenticate_user!

  def getDrivers

    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin? 

    drivers = User.all
    drivers.each do |driver|
      drivers.delete(driver) unless driver.is_driver?
    end
    render json: drivers, status: :ok
  end

end