class User < ApplicationRecord
  validates_presence_of :username, :email
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
end
