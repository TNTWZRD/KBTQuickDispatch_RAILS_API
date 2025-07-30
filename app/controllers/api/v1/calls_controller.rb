class Api::V1::CallsController < Api::V1::BaseController
    include RackSessionFix
    before_action :authenticate_user!

    def get_call
      return render json: { status: 'error', message: 'Call ID is required' }, status: :bad_request && return unless params[:id].present?
      return render json: { status: 'Unauthorized' }, status: :unauthorized && return unless hasPerms? || isDriversCall(Call.find_by(id: params[:id]))

      call = Call.find_by(id: params[:id])
      if call
        render json: call, status: :ok
      else
        render json: { status: 'error', message: 'Call not found' }, status: :not_found
      end
    end

    def get_calls
      if params[:shift_id].present?
        return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms? || isDriversShift(shift_id: params[:shift_id])
        calls = Call.where(shift_id: params[:shift_id])
      elsif params[:vehicle_id].present?
        return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms?
        calls = Call.where(vehicle_id: params[:vehicle_id])
      elsif params[:date].present?
        return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms?
        date = Date.parse(params[:date])
        calls = Call.where(scheduled_pickup_time: date.beginning_of_day..date.end_of_day)
      elsif params[:startDate].present? && params[:endDate].present?
        return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms?
        start_date = Date.parse(params[:startDate])
        end_date = Date.parse(params[:endDate])
        calls = Call.where(scheduled_pickup_time: start_date.beginning_of_day..end_date.end_of_day)
      else
        return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms?
        
        calls = Call.all
      end
      render json: { status: "ok", calls: calls }, status: :ok
    end

    def pickup_call
      return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms? || isDriversCall(Call.find_by(id: params[:id]))
      call = Call.find_by(id: params[:id])
      if call.nil?
        return render json: { status: 'error', message: 'Call not found' }, status: :not_found
      end
      return render json: { status: 'error', message: 'Call is already in progress' }, status: :unprocessable_entity if call.status == 'in_progress'
      call.pickup
      render json: { status: 'success', message: 'Call picked up successfully', call: call }, status: :ok
    end

    def dropoff_call
      return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms? || isDriversCall(Call.find_by(id: params[:id]))
      call = Call.find_by(id: params[:id])
      if call.nil?
        return render json: { status: 'error', message: 'Call not found' }, status: :not_found
      end
      return render json: { status: 'error', message: 'Call is already completed' }, status: :unprocessable_entity if call.status == 'completed'
      call.dropoff
      render json: { status: 'success', message: 'Call Dropped Off successfully', call: call }, status: :ok
    end

    def cancel_call
      return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms? || isDriversCall(Call.find_by(id: params[:id]))
      call = Call.find_by(id: params[:id])
      if call.nil?
        return render json: { status: 'error', message: 'Call not found' }, status: :not_found
      end
      if call.status == 'canceled'
        return render json: { status: 'error', message: 'Call is in canceled status already' }, status: :unprocessable_entity
      end
      call.cancel
      render json: { status: 'success', message: 'Call Canceled successfully', call: call }, status: :ok
    end

    def uncancel_call
      return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms? || isDriversCall(Call.find_by(id: params[:id]))
      call = Call.find_by(id: params[:id])
      if call.nil?
        return render json: { status: 'error', message: 'Call not found' }, status: :not_found
      end
      if call.status != 'canceled'
        return render json: { status: 'error', message: 'Call is not in canceled status' }, status: :unprocessable_entity
      end
      call.uncancel
      render json: { status: 'success', message: 'Call Uncanceled successfully', call: call }, status: :ok
    end

    def reassign_call
      return render json: { status: 'Unauthorized' }, status: :unauthorized unless hasPerms? || isDriversCall(Call.find_by(id: params[:id]))
      
      call = Call.find_by(id: params[:id])
      shift = Shift.find_by(id: params[:shift_id])
      
      return render json: { status: 'error', message: 'Call not found' }, status: :not_found if call.nil?
      return render json: { status: 'error', message: 'Shift Not Found' }, status: :not_found if shift.nil?
      return render json: { status: 'error', message: 'Shift is in the wrong status' }, status: :unprocessable_entity if !@shift.status ## Shift ended

      call.changeShift(shift)
      ActionCable.server.broadcast 'calls_channel', action: 'reassign_call', call: call.as_json
      
      render json: { status: 'success', message: 'Call Shift Changed successfully', call: call }, status: :ok
    end

    def create
      call = Call.new(params.require(:call).permit(
        :shift_id,
        :vehicle_id, 
        :status,
        :scheduled_pickup_time,
        :pickup_address,
        :dropoff_address,
        :modifers,
        :phone_number,
        :fare,
        :distance,
        :duration,
        :passenger_count, 
        :notes
      ))

      if call.save
        ActionCable.server.broadcast 'calls_channel', action: 'new_call', call: call.as_json
        render json: { status: 'success', call: call }, status: :created
      else
        render json: { status: 'error', errors: call.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      call = Call.find(params[:id])
      if call.update(params.require(:call).permit(
          :status,
          :scheduled_pickup_time,
          :pickup_address,
          :dropoff_address,
          :modifers,
          :phone_number,
          :fare,
          :distance,
          :duration,
          :passenger_count, 
          :notes
        ))
        ActionCable.server.broadcast 'calls_channel', action: 'update_call', call: call.as_json
        render json: { status: 'success', call: call }, status: :ok
      else
        render json: { status: 'error', errors: call.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      call = Call.find(params[:id])
      if call.destroy
        ActionCable.server.broadcast 'calls_channel', action: 'delete_call', call: call.as_json
        render json: { status: 'success', message: 'Call deleted successfully' }, status: :ok
      else
        render json: { status: 'error', errors: call.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { status: 'error', message: 'Call not found' }, status: :not_found
    end


    private

    def hasPerms?
      unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?
        return false
      end
      true
    end

    def isDriversShift(shift_id)
      if current_user.is_driver?
        if !current_user.driver.shifts.where(id: shift_id).exists?
          return false
        end
      end
      true
    end

    def isDriversCall(call)
      if current_user.is_driver?
        if call.shift.driver_id != current_user.driver.id
          return false
        end
      end
      true
    end
    

end