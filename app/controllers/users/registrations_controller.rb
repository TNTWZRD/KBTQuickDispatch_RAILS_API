# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  include RackSessionFix
  respond_to :json

  private 


  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: { 
        status: {code: 200, message: 'User registered successfully.'},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: {code: 200, message: 'User deleted successfully.'}
      }, status: :ok
    else
      render json: {
        status: {code: 422, message: 'User registration failed.', errors: resource.errors.full_messages},
      }, status: :unprocessable_entity
    end
  end


end
