class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true

  has_many :debit_transactions, class_name: 'Transaction', foreign_key: 'from_wallet_id'
  has_many :credit_transactions, class_name: 'Transaction', foreign_key: 'to_wallet_id'

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def recalculate_balance!
    update!(balance: credit_transactions.sum(:amount) - debit_transactions.sum(:amount))
  end

  def transactions
    Transaction
      .select("transactions.*,
        CASE
          WHEN from_wallet_id = #{id} AND type_id IN (2, 3) THEN -amount
          ELSE amount
        END AS amount")
      .where('from_wallet_id = :wallet_id OR to_wallet_id = :wallet_id', wallet_id: id)
      .order(created_at: :desc)
  end
end
