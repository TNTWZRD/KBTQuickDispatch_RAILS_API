class Api::V1::VehiclesController < Api::V1::BaseController
  before_action :authenticate_user!

  def getVehicles
    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    vehicles = Vehicle.all
    render json: vehicles, status: :ok
  end

  def create_vehicle
    vehicle_params = params.require(:vehicle).permit(:nickname, :vin_number, :license_plate, :make, :model, :year, :color, :description, :short_notes)

    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    vehicle = Vehicle.new(vehicle_params)

    if vehicle.save
      render json: {
        status: 'success',
        message: 'Vehicle created successfully',
        vehicle: vehicle
      }, status: :created
    else
      render json: {
        status: 'error',
        message: 'Failed to create vehicle',
        errors: vehicle.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update_vehicle
    vehicle = Vehicle.find_by(id: params[:id])
    return render json: {status: "Not Found"}, status: :not_found unless vehicle

    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    vehicle_params = params.require(:vehicle).permit(:nickname, :vin_number, :license_plate, :make, :model, :year, :color, :description, :short_notes, :status)

    if vehicle.update(vehicle_params)
      render json: {
        status: 'success',
        message: 'Vehicle updated successfully',
        vehicle: vehicle
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Failed to update vehicle',
        errors: vehicle.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def delete_vehicle
    vehicle = Vehicle.find_by(id: params[:id])
    return render json: {status: "Not Found"}, status: :not_found unless vehicle

    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    if vehicle.destroy
      render json: {
        status: 'success',
        message: 'Vehicle deleted successfully'
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Failed to delete vehicle',
        errors: vehicle.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

end