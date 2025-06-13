# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json

  def confirm
    if current_user
      render json: { logged_in: true, user: current_user }, status: :ok
    else
      render json: { logged_in: false }, status: :unauthorized
    end
  end

  private 

  def respond_with(current_user, _opts = {})
    if current_user.nil?
      return render json: { message: 'Invalid email or password.' }, status: :unauthorized
    end
    sign_in(current_user)
    if current_user.sign_in_count == 1
      # Ensure the user is signed in
      current_user.update(last_sign_in_at: Time.current)
    end
    render json: { message: 'Signed in successfully.', data: { user: current_user, roles: [current_user.get_roles()] } }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: 'Signed out successfully.' }, status: :ok
    else
      render json: { message: 'Not logged inn' }, status: :unauthorized
    end
  end
end
