class StatusChannel < ApplicationCable::Channel
  def subscribed

    return unauthorized unless current_user

    status = {
      status: 'online',
      user_id: current_user&.id || nil,
      username: current_user&.username || 'Anonymous',
      timestamp: Time.now.utc.iso8601
    }

    User.find(current_user.id).update(online_status: 'online') if current_user
    ActionCable.server.broadcast("status_channel", { message: "User #{current_user&.username} has subscribed to status updates.", data: status, status: status[:status] })
    stream_from "status_channel"
  end

  def unsubscribed

    return unauthorized unless current_user

    status = {
      status: 'offline',
      user_id: current_user&.id || nil,
      username: current_user&.username || 'Anonymous',
      timestamp: Time.now.utc.iso8601
    }

    # Any cleanup needed when channel is unsubscribed
    User.find(current_user.id).update(online_status: 'offline') if current_user
    logger.info "StatusChannel: User: #{current_user&.username || 'Anonymous'} unsubscribed"
    ActionCable.server.broadcast("status_channel", { message: "User #{current_user&.username} has unsubscribed from status updates.", data: status, status: status[:status] })

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
