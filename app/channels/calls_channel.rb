class CallsChannel < ApplicationCable::Channel
  def subscribed
    if current_user.nil?
      logger.warn "CallsChannel: User not authenticated, cannot subscribe"
      transmit({ error: "You must be authenticated to subscribe to calls." })
      reject
      return
    end
    stream_from "calls_channel"
    logger.info "CallsChannel: User: #{current_user.username} subscribed to calls channel"
  end

  def unsubscribed
    logger.info "CallsChannel: User: #{current_user&.username} unsubscribed from calls channel"
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
  end

  def pickup_call(data)
    call = Call.find_by(id: data['call_id'])
    if call
      call.pickup
      logger.info "Call #{call.id} picked up, User #{current_user.username}"
    else
      logger.error "Failed to pickup call #{data['call_id']}"
    end
  end

end
