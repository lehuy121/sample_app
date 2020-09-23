class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save{email.downcase!}
  validates :name, presence: true,
    length: {maximum: Settings.validate_value.max_name}
  validates :email, presence: true,
    length: {maximum: Settings.validate_value.max_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validate_value.min_password}
  has_secure_password
end
