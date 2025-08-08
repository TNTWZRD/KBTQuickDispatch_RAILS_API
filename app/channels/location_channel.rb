class LocationChannel < ApplicationCable::Channel

  def subscribed

    if current_user.nil?
      logger.warn "LocationChannel: User not authenticated, cannot subscribe"
      transmit({ error: "You must be authenticated to subscribe to LocationChannel updates." })
      reject
      return
    end

    unless defined?(@@broadcast_timer) && @@broadcast_timer.running?
      @@broadcast_timer = Concurrent::TimerTask.new(execution_interval: 60) do
        ActionCable.server.broadcast("location_channel", { update: true })
      end
      @@broadcast_timer.execute
    end


    logger.info "LocationChannel: User: #{current_user&.username || 'Anonymous'} subscribed"
    ActionCable.server.broadcast("location_channel", { message: "User #{current_user&.username || 'Anonymous'} has joined the LocationChannel." })
    stream_from "location_channel"
  end

  def unsubscribed
    logger.info "LocationChannel: User: #{current_user&.username || 'Anonymous'} unsubscribed"

    checkDead
  end

  def checkDead
    if defined?(@@broadcast_timer) && @@broadcast_timer.running?
      if SolidCable.subscribers("location_channel").zero?
        @@broadcast_timer.shutdown
        logger.info "LocationChannel: Broadcast timer stopped."
      end
    end
  end

  def receive(data)

    if defined?(@@broadcast_timer) && @@broadcast_timer.running?
      if SolidCable.subscribers("location_channel").zero?
        @@broadcast_timer.shutdown
        logger.info "LocationChannel: Broadcast timer stopped."
      end
    end

    logger.debug "LocationChannel: Received data: #{data.inspect}"

    location_data = {
      latitude: data['latitude'],
      longitude: data['longitude'],
      altitude: data['altitude'],
      heading: data['heading'],
      speed: data['speed'],
      isMobile: data['isMobile'] || false, # Default to false if not provided
      user_id: current_user&.id || nil,
      username: current_user&.username || 'Anonymous',
      timestamp: Time.now.utc.iso8601
    }

    logger.info "LocationChannel: Received data: #{data}, from User: #{current_user&.username || 'Anonymous'} "
    ActionCable.server.broadcast("location_channel", location_data)
  end

  def location_update(data)
    logger.debug "LocationChannel: Received message data: #{data.inspect}"

    location_data = {
      latitude: data['latitude'],
      longitude: data['longitude'],
      altitude: data['altitude'],
      heading: data['heading'],
      speed: data['speed'],
      isMobile: data['isMobile'] || false,
      user_id: current_user&.id || nil,
      username: current_user&.username || 'Anonymous',
      timestamp: Time.now.utc.iso8601,
      message: "User #{current_user&.username || 'Anonymous'} sent GPS Data."
    }

    LocationHistory.create(
      latitude: data['latitude'],
      longitude: data['longitude'],
      altitude: data['altitude'],
      heading: data['heading'],
      speed: data['speed'],
      is_mobile: data['isMobile'] || false,
      user_id: current_user&.id || nil
    ) if current_user # Save location history if user is authenticated

    logger.info "LocationChannel: Received message from User: #{current_user&.username || 'Anonymous'} "
    ActionCable.server.broadcast("location_channel", location_data)
  end
end
