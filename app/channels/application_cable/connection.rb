require 'jwt'

module ApplicationCable

  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      logger.info "WebSocket connection attempt from #{request.remote_ip}"
      logger.info "Headers: #{request.headers.to_h}"
      
      self.current_user = find_verified_user

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

    protected

    def find_verified_user
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end

  end
end
