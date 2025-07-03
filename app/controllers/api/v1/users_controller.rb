class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!

  def getUsers 
    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_dispatcher? || current_user.is_manager? || current_user.is_owner? || current_user.is_admin?

    users = User.all.select(:id, :name, :email, :username, :phone_number, :darkmode, :role, :driver_id)
    render json: users, status: :ok

  end

  # Update user profile information
  def update_profile
    user_params = params.require(:user).permit(:name, :email, :username, :phone_number)
    
    if current_user.update(user_params)
      render json: {
        status: 'success',
        message: 'Profile updated successfully',
        user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Failed to update profile',
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update_roles()
    role_params = params.require([:user_id, :role])
    puts role_params.inspect
    role = role_params[1]
    user_id = role_params[0]
    if role >= 16 && !current_user.is_admin?
      render json: {
        status: 'Unauthorized',
        message: 'unauthorized to change roles above admin level'
      }, status: :unauthorized
      return
    end
    if role >= 8 && (!current_user.is_owner? && !current_user.is_admin?)
      render json: {
        status: 'Unauthorized',
        message: 'unauthorized to change roles above owner level'
      }, status: :unauthorized
      return
    end
    if role >= 4 && (!current_user.is_manager? && !current_user.is_owner? && !current_user.is_admin?)
      render json: {
        status: 'Unauthorized',
        message: 'unauthorized to change roles above manager level'
      }, status: :unauthorized
      return
    end
    if !role || role < 0 || role > 31
      render json: {
        status: 'error',
        message: 'Invalid role value'
      }, status: :unprocessable_entity
      return
    end
    user = User.find(user_id)
    if user.nil?
      render json: {
        status: 'error',
        message: 'User not found'
      }, status: :not_found
      return
    end
    if user.update(role: role)
      if role & 1 == 1 then
        # If the user is a driver, create a driver record if it doesn't exist
        Driver.create_with(phone_number: user.phone_number || 0).find_or_create_by(user_id: user.id) unless user.driver
        Driver.where(user_id: user_id).update(status: 1) unless !user.driver
      else
        Driver.where(user_id: user.id).update(status: 0) if user.driver
      end
      render json: {
        status: 'success',
        message: 'User role updated successfully',
        user: UserSerializer.new(user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Failed to update user role',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update_user 
    user_params = params.require(:user).permit(:name, :email, :username, :phone_number, :darkmode, :role)
    render json: {status: "Unauthorized"}, status: :unauthorized unless current_user.is_manager? || current_user.is_owner? || current_user.is_admin?
    role = user_params[:role]
    user = User.find_by(id: params[:id])
    if user.nil?
      render json: {
        status: 'error',
        message: 'User not found'
      }, status: :not_found
      return
    end

    if user.update(user_params)

      if role & 1 == 1 then
        # If the user is a driver, create a driver record if it doesn't exist
        Driver.create_with(phone_number: user.phone_number || 0).find_or_create_by(user_id: user.id) unless user.driver
        Driver.where(user_id: user_id).update(status: 1) unless !user.driver
      else
        Driver.where(user_id: user.id).update(status: 0) if user.driver
      end

      render json: {
        status: 'success',
        message: 'User updated successfully',
        user: UserSerializer.new(user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Failed to update user',
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def delete_user
    user_id = params[:id]
    render json: { status: 'error', message: 'User ID is required' }, status: :bad_request and return if user_id.blank?
    render json: { status: 'Unauthorized' }, status: :unauthorized unless current_user.is_manager? || current_user.is_owner? || current_user.is_admin?
    user = User.find_by(id: user_id)
    render json: { status: 'error', message: 'User not found' }, status: :not_found and return if user.nil?
    if user.driver
      user.driver.update(user_id: nil, status: 0) # Unlink driver from user and set status to inactive
      user.update(driver_id: nil) # Unlink driver_id from user
    end
    if user.destroy
      render json: { status: 'success', message: 'User deleted successfully' }, status: :ok
    else
      render json: { status: 'error', message: 'Failed to delete user', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Update user preferences
  def update_preferences
    preference_params = params.require(:user).permit(:darkmode)
    
    if current_user.update(preference_params)
      render json: {
        status: 'success',
        message: 'Preferences updated successfully',
        user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      puts current_user.errors.full_messages
      render json: {
        status: 'error',
        message: 'Failed to update preferences',
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # Change user password
  def change_password
    password_params = params.require(:user).permit(:current_password, :password, :password_confirmation)
    
    # Verify current password
    unless current_user.valid_password?(password_params[:current_password])
      render json: {
        status: 'error',
        message: 'Current password is incorrect'
      }, status: :unprocessable_entity
      return
    end

    # Check password confirmation
    if password_params[:password] != password_params[:password_confirmation]
      render json: {
        status: 'error',
        message: 'Password confirmation does not match'
      }, status: :unprocessable_entity
      return
    end

    # Update password
    if current_user.update(password: password_params[:password])
      render json: {
        status: 'success',
        message: 'Password changed successfully'
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Failed to change password',
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :username, :phone_number, :darkmode)
  end
end
