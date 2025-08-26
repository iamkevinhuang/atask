class Transactions::Deposit < Transaction
  before_create :set_transaction_type

  def apply_to_wallets
    to_wallet.recalculate_balance!
  end

  private

  def set_transaction_type
    self.type_id = 1
  end
end
