class ConnectionsController < ApplicationController
  before_action :require_login

  def index
    @pending_requests = current_user.received_connection_requests.where(status: 'pending').includes(:sender)
    @connected_users = current_user.connected_users
    
    excluded_ids = [current_user.id] + 
                   current_user.sent_connection_requests.pluck(:receiver_id) +
                   current_user.received_connection_requests.pluck(:sender_id)
                   
    @people_you_may_know = User.where.not(id: excluded_ids).limit(12)
  end

  def create
    receiver = User.find(params[:receiver_id])
    connection = current_user.sent_connection_requests.build(receiver: receiver, status: 'pending')

    if connection.save
      redirect_to connections_path, notice: "Connection request sent to #{receiver.email}."
    else
      redirect_to connections_path, alert: "Could not send connection request."
    end
  end

  def update
    connection = current_user.received_connection_requests.find(params[:id])
    if params[:status] == 'accepted' && connection.update(status: 'accepted')
      redirect_to connections_path, notice: "You are now connected with #{connection.sender.email}."
    else
      redirect_to connections_path, alert: "Could not accept request."
    end
  end

  def destroy
    connection = Connection.find(params[:id])
    
    if connection.sender_id == current_user.id || connection.receiver_id == current_user.id
      connection.destroy
      redirect_to connections_path, notice: "Connection updated."
    else
      redirect_to connections_path, alert: "Unauthorized action."
    end
  end
end
