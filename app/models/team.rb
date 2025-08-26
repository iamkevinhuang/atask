class Team < ApplicationRecord
  include WalletHolder

  has_one :wallet, as: :owner

  validates :title, presence: true
  validates :title, uniqueness: true
end
