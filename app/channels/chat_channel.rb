class ChatChannel < ApplicationCable::Channel

  def subscribed

    if current_user.nil?
      logger.warn "ChatChannel: User not authenticated, cannot subscribe"
      transmit({ error: "You must be authenticated to subscribe to chat updates." })
      reject
      return
    end


    logger.info "ChatChannel: User: #{current_user&.username || 'Anonymous'} subscribed"
    ActionCable.server.broadcast("chat_channel", { message: "User #{current_user&.username || 'Anonymous'} has joined the chat." })
    stream_from "chat_channel"
  end

  def unsubscribed
    logger.info "ChatChannel: User: #{current_user&.username || 'Anonymous'} unsubscribed"
    ActionCable.server.broadcast("chat_channel", { message: "User #{current_user&.username || 'Anonymous'} has left the chat." })
  end

  def receive(data)
    chat = {
      message: data['message'],
      user_id: current_user&.id || nil,
      username: current_user&.username || 'Anonymous',
      timestamp: Time.now.utc.iso8601
    }

    logger.info "ChatChannel: Received data: #{data}, from User: #{current_user&.username || 'Anonymous'} "
    ActionCable.server.broadcast("chat_channel", chat)
  end
end
