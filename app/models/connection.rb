class Connection < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :status, presence: true, inclusion: { in: %w[pending accepted] }
  validates :receiver_id, uniqueness: { scope: :sender_id, message: "Connection request already exists" }
  validate :cannot_connect_with_self

  private

  def cannot_connect_with_self
    if sender_id == receiver_id
      errors.add(:receiver_id, "You cannot connect with yourself")
    end
  end
end
