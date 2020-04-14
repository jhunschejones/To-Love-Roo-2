class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  # there are only 2 users at the moment
  def other_user
    if is_joshua?
      User.where(email: ENV["ROO_EMAIL"]).first
    else
      User.where(email: ENV["JOSHUA_EMAIL"]).first
    end
  end

  def is_joshua?
    email == ENV["JOSHUA_EMAIL"]
  end

  def is_roo?
    email == ENV["ROO_EMAIL"]
  end
end
