class ChatChannel < ApplicationCable::Channel
  def subscribed
    logger.info "ChatChannel: User subscribed"
    stream_from "chat_channel"
  end

  def unsubscribed
    logger.info "ChatChannel: User unsubscribed"
  end

  def receive(data)
    logger.info "ChatChannel: Received data: #{data}"
    ActionCable.server.broadcast("chat_channel", data)
  end
end
