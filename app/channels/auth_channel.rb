class AuthChannel < ApplicationCable::Channel
  def subscribed
    logger.info "AuthChannel subscribed, #{connection.request_info.remote_ip} , User: #{current_user&.username || 'Anonymous'}, Timestamp: #{Time.now.utc.iso8601}"
  end

  def unsubscribed
    logger.info "AuthChannel unsubscribed, #{connection.request_info.remote_ip} , User: #{current_user&.username || 'Anonymous'}, Timestamp: #{Time.now.utc.iso8601}"
  end

  def authenticate(data)
    logger.info "Authentication attempt received"
    
    begin
      # Try JWT token first (for React/API clients)
      if data['token'] && (user = find_jwt_user(data['token']))
        connection.authenticate_user!(user)
        transmit({
          type: 'authentication_success',
          user: {
            id: user.id,
            username: user.username
          }
        })
        logger.info "JWT Authentication successful for user: #{user.username}"
      # Try to authenticate using Warden first
      elsif user = find_warden_user
        connection.authenticate_user!(user)
        transmit({
          type: 'authentication_success',
          user: {
            id: user.id,
            username: user.username
          }
        })
        logger.info "Authentication successful for user: #{user.username}"
      else
        # If Warden fails, could implement token-based auth here
        handle_authentication_failure("No authenticated user found")
      end
    rescue => e
      logger.error "Authentication error: #{e.message}"
      handle_authentication_failure(e.message)
    end
  end

  private

  def find_jwt_user(token)
    return nil unless token

    begin
      # Use Devise JWT to decode the token
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base!, true, { algorithm: 'HS256' })
      user_id = decoded_token[0]['sub']
      User.find(user_id)
    rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound => e
      logger.warn "JWT decode error: #{e.message}"
      nil
    end
  end

  def find_warden_user
    connection.env['warden']&.user
  end

  def handle_authentication_failure(reason)
    transmit({
      type: 'authentication_error',
      message: reason
    })
    logger.warn "Authentication failed: #{reason}"
  end
end
