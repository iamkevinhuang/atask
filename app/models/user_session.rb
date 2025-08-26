class UserSession < ApplicationRecord
  belongs_to :user

  validates :user_agent, :auth_token, presence: true
  validates :auth_token, uniqueness: true

  def self.find_by_auth_token(token)
    find_by(auth_token: token)
  end
end
