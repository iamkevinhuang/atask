class User < ApplicationRecord
  include WalletHolder

  has_one :wallet, as: :owner
  has_many :sessions, class_name: "UserSession", dependent: :destroy

  attribute :password, :string

  validates :name, :username, presence: true
  validates :username, uniqueness: true

  before_save :generate_password_digest!

  def self.authenticate(username, password, user_agent)
    user = find_by(username: username)

    return {
      success: false,
      data: { error: I18n.t("session.errors.invalid_credential") }
    } unless user && user.password_digest == Digest::SHA256.base64digest(password)

    user.save_session(user_agent)
  end

  def save_session(user_agent)
    session = sessions.new(auth_token: SecureRandom.hex(32), user_agent:)

    return {
      success: true,
      data: {
        user: UserBlueprint.render_as_hash(self),
        auth_token: session.auth_token
      }
    } if session.save

    {
      success: false,
      data: { error: session.errors.full_messages.first }
    }
  end

  private

  def generate_password_digest!
    self.password_digest = Digest::SHA256.base64digest(password) if password.present?
  end
end
