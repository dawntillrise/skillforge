class MessagesController < ApplicationController
  before_action :require_login

  def index
    @connected_users = current_user.connected_users
    
    if params[:user_id]
      @active_user = User.find(params[:user_id])
      unless current_user.connected_with?(@active_user)
        redirect_to messages_path, alert: "You can only message connected users."
        return
      end
      
      @messages = Message.where(sender: current_user, receiver: @active_user)
                         .or(Message.where(sender: @active_user, receiver: current_user))
                         .order(created_at: :asc)
      @new_message = Message.new
    end
  end

  def create
    @receiver = User.find(params[:message][:receiver_id])
    unless current_user.connected_with?(@receiver)
      head :unauthorized
      return
    end

    @message = current_user.sent_messages.build(message_params)
    
    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to messages_path(user_id: @receiver.id) }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end
end
