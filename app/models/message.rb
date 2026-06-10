class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :content, presence: true

  # Broadcast to the conversation streams for both perspectives
  after_create_commit -> {
    # Sender's perspective
    broadcast_append_to(
      "conversation_#{sender_id}_with_#{receiver_id}",
      target: "messages",
      partial: "messages/message",
      locals: { message: self, perspective_user_id: sender_id }
    )
    # Receiver's perspective
    broadcast_append_to(
      "conversation_#{receiver_id}_with_#{sender_id}",
      target: "messages",
      partial: "messages/message",
      locals: { message: self, perspective_user_id: receiver_id }
    )
  }
end
