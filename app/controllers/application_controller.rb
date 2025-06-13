class ApplicationController < ActionController::API
  include RackSessionFix
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Respond to JSON format by default
  respond_to :json

  protected

  # Configure parameters for devise
  def configure_permitted_parameters
    added_attrs = [:name, :phone_number, :username, :role, :driver_id, :status, :email, :darkmode]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end


end
