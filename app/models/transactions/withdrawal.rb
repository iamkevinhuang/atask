class Transactions::Withdrawal < Transaction
  before_create :set_transaction_type
  validate :is_enough_balance?

  def apply_to_wallets
    from_wallet.recalculate_balance!
  end

  private

  def set_transaction_type
    self.type_id = 2
  end
end
