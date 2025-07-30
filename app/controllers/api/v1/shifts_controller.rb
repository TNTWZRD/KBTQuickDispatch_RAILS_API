class Api::V1::ShiftsController < Api::V1::BaseController
  include RackSessionFix
  before_action :authenticate_user!

  def get_shifts
    render json: { status: 'Unauthorized' }, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    shifts = Shift.all.order(:start_time).select(:id, :start_time, :end_time, :status, :driver_id)
    render json: shifts, status: :ok
  end

  def get_shift
    render json: { status: 'Unauthorized' }, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    shift = Shift.find_by(id: params[:id])
    if shift
      render json: shift, status: :ok
    else
      render json: { status: 'error', message: 'Shift not found' }, status: :not_found
    end
  end

  def update
    render json: { status: 'Unauthorized' }, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    shift_params = params.require(:shift).permit(:start_time, :end_time, :status, :driver_id)
    shift = Shift.find_by(id: params[:id])

    if shift.nil?
      render json: { status: 'error', message: 'Shift not found' }, status: :not_found
      return
    end

    if shift.update(shift_params)
      ActionCable.server.broadcast 'shifts_channel', action: 'update_shift', shift: shift.as_json
      render json: { status: 'success', message: 'Shift updated successfully', shift: shift }, status: :ok
    else
      render json: { status: 'error', message: 'Failed to update shift', errors: shift.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    render json: { status: 'Unauthorized' }, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    shift_params = params.require(:shift).permit(:start_time, :end_time, :status, :driver_id)
    shift = Shift.new(shift_params)

    if shift.save
      ActionCable.server.broadcast 'shifts_channel', action: 'new_shift', shift: shift.as_json
      render json: { status: 'success', message: 'Shift created successfully', shift: shift }, status: :created
    else
      render json: { status: 'error', message: 'Failed to create shift', errors: shift.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: { status: 'Unauthorized' }, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    shift = Shift.find_by(id: params[:id])
    if shift.nil?
      render json: { status: 'error', message: 'Shift not found' }, status: :not_found
      return
    end

    if shift.destroy
      ActionCable.server.broadcast 'shifts_channel', action: 'delete_shift', shift: shift.as_json
      render json: { status: 'success', message: 'Shift deleted successfully' }, status: :ok
    else
      render json: { status: 'error', errors: shift.errors.full_messages }, status: :unprocessable_entity
    end
  end

end