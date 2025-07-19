require 'jwt'

module ApplicationCable

  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      logger.info "WebSocket connection attempt from #{request.remote_ip}"
      logger.info "Headers: #{request.headers.to_h}"
      
      self.current_user = authenticate_user!

      if current_user.nil?
        logger.warn "WebSocket connection rejected: User not authenticated"
        reject_unauthorized_connection
      end

      logger.info "User ID: #{current_user&.id}"
      logger.info "Authenticated user: #{current_user&.username}"
    end

    def disconnect
      logger.info "WebSocket disconnected for user: #{current_user&.username}"
    end

    private

    def authenticate_user!
      token = extract_token_from_header

      # If no token is provided, return nil this allows unauthenticated connections
      # This can be useful for public channels or debugging purposes
      # If you want to enforce authentication, you can raise an error here instead
      # raise 'Unauthorized' unless token
      # For now, we will just log the absence of a token
      logger.warn "No token provided for WebSocket connection" unless token
      return reject_unauthorized_connection unless token

      begin
        decoded_token = JWT.decode(
          token,
          Rails.application.credentials.fetch(:secret_key_base),
          true,
          { algorithm: 'HS256' }
        )
        
        user_id = decoded_token[0]['sub']
        jti = decoded_token[0]['jti']
        
        user = User.find(user_id)
        
        # Verify the JTI matches (for token revocation)
        return reject_unauthorized_connection unless user.jti == jti
        
        user
      rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound => e
        logger.error "JWT authentication failed: #{e.message}"
        reject_unauthorized_connection
      end
    end

    def extract_token_from_header
      auth_header = request.headers['Authorization']
      return nil unless auth_header&.start_with?('Bearer ')
      
      auth_header.split(' ').last
    end
  end
end
