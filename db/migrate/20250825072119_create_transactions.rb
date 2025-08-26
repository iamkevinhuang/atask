class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.integer :type_id
      t.decimal :amount
      t.string :description
      t.references :from_wallet, null: true, foreign_key: { to_table: :wallets }
      t.references :to_wallet, null: true, foreign_key: { to_table: :wallets }

      t.timestamps
    end
  end
end
