class AddBalanceToWallets < ActiveRecord::Migration[8.0]
  def change
    add_column :wallets, :balance, :decimal, default: 0
  end
end
