class User < ApplicationRecord
  has_secure_password

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: URI::MailTo::EMAIL_REGEXP
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?

  has_many :sent_connection_requests, class_name: "Connection", foreign_key: "sender_id", dependent: :destroy
  has_many :received_connection_requests, class_name: "Connection", foreign_key: "receiver_id", dependent: :destroy

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy

  def connected_users
    sent_users = User.joins(:received_connection_requests).where(connections: { sender_id: self.id, status: 'accepted' })
    received_users = User.joins(:sent_connection_requests).where(connections: { receiver_id: self.id, status: 'accepted' })
    User.where(id: (sent_users.pluck(:id) + received_users.pluck(:id)).uniq)
  end

  def connection_status_with(other_user)
    Connection.where(sender_id: id, receiver_id: other_user.id)
              .or(Connection.where(sender_id: other_user.id, receiver_id: id))
              .first&.status
  end

  def connected_with?(other_user)
    connection_status_with(other_user) == 'accepted'
  end
  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
