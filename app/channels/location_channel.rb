class LocationChannel < ApplicationCable::Channel

  def subscribed

    if current_user.nil?
      logger.warn "LocationChannel: User not authenticated, cannot subscribe"
      transmit({ error: "You must be authenticated to subscribe to LocationChannel updates." })
      reject
      return
    end

    logger.info "LocationChannel: User: #{current_user&.username || 'Anonymous'} subscribed"
    ActionCable.server.broadcast("location_channel", { message: "User #{current_user&.username || 'Anonymous'} has joined the LocationChannel." })
    stream_from "location_channel"
  end

  def unsubscribed
    logger.info "LocationChannel: User: #{current_user&.username || 'Anonymous'} unsubscribed"
  end

  def receive(data)


    logger.debug "LocationChannel: Received data: #{data.inspect}"

    logger.info "LocationChannel: Received data: #{data}, from User: #{current_user&.username || 'Anonymous'} "
    
  end

  def location_update(data)
    logger.debug "LocationChannel: Received message data: #{data.inspect}"
    if data['latitude'].nil? || data['longitude'].nil?
      logger.warn "LocationChannel: Invalid location data received from User: #{current_user&.username || 'Anonymous'}"
      transmit({ error: "Invalid location data received." })
      return
    end

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
      ipaddress: current_user&.current_sign_in_ip || '',
      message: "User #{current_user&.username || 'Anonymous'} sent GPS Data."
    }

    LocationHistory.create(
      latitude: data['latitude'],
      longitude: data['longitude'],
      altitude: data['altitude'],
      heading: data['heading'],
      speed: data['speed'],
      is_mobile: data['isMobile'] || false,
      user_id: current_user&.id || nil,
      ipaddress: current_user&.current_sign_in_ip || '',
    ) if current_user # Save location history if user is authenticated

    logger.info "LocationChannel: Received message from User: #{current_user&.username || 'Anonymous'} "
    ActionCable.server.broadcast("location_channel", location_data)
  end
end
