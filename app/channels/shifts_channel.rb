class ShiftsChannel < ApplicationCable::Channel

  def subscribed
    if current_user.nil?
      logger.warn "ShiftsChannel: User not authenticated, cannot subscribe"
      transmit({ error: "You must be authenticated to subscribe to shifts updates." })
      reject
      return
    end

    logger.info "ShiftsChannel: User: #{current_user&.username} subscribed"
    stream_from "shifts_channel"
  end

  def unsubscribed
    logger.info "ShiftsChannel: User: #{current_user&.username} unsubscribed"
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)

    shift = data['shift']

    # Handle incoming data from the client
    logger.info "ShiftsChannel: Received data: #{data}, from User: #{current_user&.username}"
    
    # Broadcast the received data to all subscribers
    ActionCable.server.broadcast("shifts_channel", {
      message: data['message'],
      user_id: current_user&.id || nil,
      username: current_user&.username,
      timestamp: Time.now.utc.iso8601
    })
  end
end
