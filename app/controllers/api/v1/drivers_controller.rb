class Api::V1::DriversController < Api::V1::BaseController
  include RackSessionFix
  before_action :authenticate_user!

  def getDrivers

    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin? 

    drivers = Driver.all.order(:name).select(:id, :name, :phone_number, :user_id, :status, :emergency_contact_names, :emergency_contact_numbers)
    # drivers = User.where('role & ? = ?', 1, 1)
    drivers = drivers.map do |driver|
      driver.name = driver.user.name if driver.user.present? && driver.name.blank?
      driver
    end
    render json: drivers, status: :ok
  end

  def update_driver
    driver_params = params.require(:driver).permit(:id, :name, :phone_number, :status, :emergency_contact_names, :emergency_contact_numbers)
    
    driver = Driver.find_by(id: driver_params[:id])
    
    if driver.nil?
      render json: { status: 'error', message: 'Driver not found' }, status: :not_found
      return
    end

    if driver.update(driver_params)
      render json: { status: 'success', message: 'Driver updated successfully', driver: driver }, status: :ok
    else
      render json: { status: 'error', message: 'Failed to update driver', errors: driver.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_driver
    driver_params = params.require(:driver).permit(:name, :phone_number, emergency_contact_names: [], emergency_contact_numbers: [])
    driver_params[:emergency_contact_names] = driver_params[:emergency_contact_names].to_json if driver_params[:emergency_contact_names].is_a?(Array)
    driver_params[:emergency_contact_numbers] = driver_params[:emergency_contact_numbers].to_json if driver_params[:emergency_contact_numbers].is_a?(Array)
    driver = Driver.new(driver_params)
    driver.status = 1 # Default status to active
    if driver.save
      render json: { status: 'success', message: 'Driver created successfully', driver: driver }, status: :created
    else
      render json: { status: 'error', message: 'Failed to create driver', errors: driver.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete_driver
    driver_id = params[:id]
    
    render json: { status: 'error', message: 'Driver ID is required' }, status: :bad_request and return if driver_id.blank?
    render json: { status: 'Unauthorized' }, status: :unauthorized unless current_user.is_manager? || current_user.is_owner? || current_user.is_admin?
    
    driver = Driver.find_by(id: driver_id)
    
    render json: { status: 'error', message: 'Has a user account, Delete From There.' }, status: :unprocessable_entity and return if driver.user.present?

    if driver.nil?
      render json: { status: 'error', message: 'Driver not found' }, status: :not_found
      return
    end

    if driver.destroy
      render json: { status: 'success', message: 'Driver deleted successfully' }, status: :ok
    else
      render json: { status: 'error', message: 'Failed to delete driver', errors: driver.errors.full_messages }, status: :unprocessable_entity
    end
  end

end