class Api::V1::DriversController < Api::V1::BaseController
  include RackSessionFix
  before_action :authenticate_user!

  def getDrivers

    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin? 

    drivers = Driver.all.order(:name).select(:id, :name, :phone_number, :user_id, :status)
    # drivers = User.where('role & ? = ?', 1, 1)
    render json: drivers, status: :ok
  end

end