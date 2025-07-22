require 'jwt'

module ApplicationCable

  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    identified_by :request_info

    def connect
      logger.info "WebSocket connection attempt from #{request.remote_ip}"
      self.request_info = request
      # Allow all connections initially - authentication happens in AuthChannel
      self.current_user = nil
      #puts request.headers.map { |k, v| "#{k}: #{v}" }.join("\n")

      logger.info "WebSocket connection established"
    end

    def disconnect
      current_user&.update(online_status: 'offline') if current_user
      
      # Any cleanup needed when channel is disconnected
      logger.info "WebSocket disconnected for user: #{current_user&.username || 'Unauthenticated'}"
    end

    # Method to set the current user after authentication
    def authenticate_user!(user)
      self.current_user = user
      logger.info "User authenticated: #{user.username} (ID: #{user.id})"
      user.update(online_status: 'online') if user
      ActionCable.server.broadcast("status_channel", { message: "User #{user.username} has updated their status.", data: { online_status: 'online' }, status: 'online' })
    end

  end
end
