class Api::V1::DriversController < Api::V1::BaseController
  include RackSessionFix
  before_action :authenticate_user!

  def getDrivers
    drivers = User.all
    drivers.each do |driver|
      drivers.delete(driver) unless driver.is_driver()
    end
    render json: drivers, status: :ok
  end

end