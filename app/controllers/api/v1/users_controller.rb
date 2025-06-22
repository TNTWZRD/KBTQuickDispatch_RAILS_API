class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!

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
