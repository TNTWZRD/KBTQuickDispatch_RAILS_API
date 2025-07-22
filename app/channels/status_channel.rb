class StatusChannel < ApplicationCable::Channel

  def subscribed
    if current_user.nil?
      logger.warn "StatusChannel: User not authenticated, cannot subscribe"
      transmit({ error: "You must be authenticated to subscribe to status updates." })
      reject
      return
    end

    status = {
      status: 'online',
      user_id: current_user&.id || nil,
      username: current_user&.username || 'Anonymous',
      timestamp: Time.now.utc.iso8601
    }

    User.find(current_user.id).update(online_status: 'online') if current_user
    stream_from "status_channel"
  end

  def unsubscribed

    status = {
      status: 'offline',
      user_id: current_user&.id || nil,
      username: current_user&.username || 'Anonymous',
      timestamp: Time.now.utc.iso8601
    }

    # Any cleanup needed when channel is unsubscribed
    logger.info "StatusChannel: User: #{current_user&.username || 'Anonymous'} unsubscribed"

  end

  def receive(data)

    allow_values = ['online', 'offline', 'away', 'busy']
    unless allow_values.include?(data['status'])
      logger.warn "StatusChannel: Invalid status value received: #{data['status']}"
      return 
    end
    
    status = {
      status: data['status'],
      user_id: current_user&.id || nil,
      username: current_user&.username,
      timestamp: Time.now.utc.iso8601
    }
    
    User.find(current_user.id).update(online_status: data['status']) if current_user

    logger.info "StatusChannel: User: #{current_user&.username} updated status"
    ActionCable.server.broadcast("status_channel", { message: "User #{current_user&.username} has updated their status.", data: status, status: status[:status] })
  end
end
