# frozen_string_literal: true

class TransactionBlueprint < Blueprinter::Base
  identifier :id

  field :amount do |transaction|
    transaction.amount.to_f
  end

  fields :description, :created_at, :transaction_type

  field :from_wallet do |transaction|
    WalletBlueprint.render_as_hash(transaction.from_wallet).except(:balance) if transaction.from_wallet
  end

  field :to_wallet do |transaction|
    WalletBlueprint.render_as_hash(transaction.to_wallet).except(:balance) if transaction.to_wallet
  end
end
