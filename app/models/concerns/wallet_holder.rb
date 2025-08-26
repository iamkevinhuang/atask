module WalletHolder
  extend ActiveSupport::Concern

  included do
    has_one :wallet, as: :owner, dependent: :destroy
    after_create :generate_wallet!
  end

  private

  def generate_wallet!
    create_wallet!
  end
end
