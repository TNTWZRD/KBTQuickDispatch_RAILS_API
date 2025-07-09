module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      logger.info "WebSocket connection attempt from #{request.remote_ip}"
      logger.info "Headers: #{request.headers.to_h}"
    end

    def disconnect
      logger.info "WebSocket disconnected"
    end
  end
end
