# class User
class User < ApplicationRecord
  # auth
  has_secure_password

  # associations
  has_one :preference

  # validations
  validates :password_confirmation, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # authentication method
  def self.authenticate_with_credentials(email, password)
    user = User.where('lower(email) = ?', email.strip.downcase).first
    # user = User.find_by_email(email.strip)
    user && user.authenticate(password) ? user : nil
  end
end
