class Transactions::Transfer < Transaction
  before_create :set_transaction_type

  def apply_to_wallets
    from_wallet.recalculate_balance!
    to_wallet.recalculate_balance!
  end

  private

  def set_transaction_type
    self.type_id = 3
  end
end
