class User < ApplicationRecord
  has_secure_password

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: URI::MailTo::EMAIL_REGEXP
  validates :password, presence: true, length: { minimum: 6 }, if: :password_digest_changed?

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
