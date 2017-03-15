class MessagesController < ApplicationController

  def index
    @messages = Message.all.order(id: :desc)
  end

  def create
    @message = Message.new message_params
    if @message.save
      flash[:success] = "Message created successfully"
      redirect_to messages_path
      ActionCable.server.broadcast 'chat', message: render_message(@message)
    else
      render 'index'
      flash.now[:error] = "Cannot create the message"
    end
  end

  private

  def render_message(message)
     ApplicationController.render(partial: 'messages/message', locals: {message: message})    
  end 

  def message_params
    params.require(:message).permit(:body)
  end 
  

end
