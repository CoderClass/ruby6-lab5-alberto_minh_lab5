class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat"
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    Rails.logger.info("MessagesChannel got: #{data.inspect}")
    @message = Message.create(data['message'])
    if @message.persisted?
      ActionCable.server.broadcast("chat",message: render_message(@message))
    end
  end


  def render_message(message)
    ApplicationController.render(partial: 'messages/message', locals: {message: message})
  end



end
