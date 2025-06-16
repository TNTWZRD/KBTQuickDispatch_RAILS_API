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
    render json: {
      status: { code: 200, message: 'User logged in successfully.' },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: { code: 200, message: 'User logged out successfully.' }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: 'User not logged in.' }
      }, status: :unauthorized
    end
  end
end
