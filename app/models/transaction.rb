class Transaction < ApplicationRecord
  # self.inheritance_column = :type_id

  belongs_to :from_wallet, optional: true, class_name: "Wallet", foreign_key: "from_wallet_id"
  belongs_to :to_wallet, optional: true, class_name: "Wallet", foreign_key: "to_wallet_id"

  validates :amount, numericality: { greater_than: 0 }
  validate :valid_wallet_is_exist?
  validate :is_enough_balance?

  TRANSACTION_TYPES = {
    1 => "deposit",
    2 => "withdrawal",
    3 => "transfer"
  }.freeze

  def transaction_type
    I18n.t("transaction.types.#{TRANSACTION_TYPES[type_id]}", default: "Unknown Transaction Type")
  end

  def self.execute_transaction(transaction)
    ActiveRecord::Base.transaction do
      transaction.save!
      transaction.apply_to_wallets
      transaction
    end
  end

  private

  def valid_wallet_is_exist?
    case type_id
    when 1
      errors.add(:to_wallet, I18n.t("transaction.errors.deposit_wallet_required")) if to_wallet.nil?
    when 2
      errors.add(:from_wallet, I18n.t("transaction.errors.withdrawal_wallet_required")) if from_wallet.nil?
    when 3
      if from_wallet.nil? || to_wallet.nil?
        errors.add(:base, I18n.t("transaction.errors.transfer_wallets_required"))
      end
    end
  end

  def is_enough_balance?
    errors.add(:amount, I18n.t("transaction.errors.exceeds_balance")) if from_wallet && amount > from_wallet&.balance
  end
end
