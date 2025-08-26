class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :initial_wallet

  def show
    render json: WalletBlueprint.render_as_hash(@current_user.wallet), status: :ok
  end

  def transactions
    transactions = @current_user.wallet.transactions.order(created_at: :desc)
    data = pagination_helper(transactions, TransactionBlueprint, params[:limit], params[:page])

    render json: data[0], status: data[1]
  end

  def deposit
    transaction = Transactions::Deposit.new(
      amount: params[:amount],
      to_wallet: @current_user.wallet,
      description: params[:description]
    )

    if Transaction.execute_transaction(transaction)
      render json: {
        message: I18n.t('transaction.messages.created', type: 'Deposit'),
        new_balance: @current_user.wallet.balance&.to_f
      }, status: :created
    else
      render json: { error: transaction.errors.full_messages.first }, status: :unprocessable_entity
    end
  end

  def withdraw
    transaction = Transactions::Withdrawal.new(
      amount: params[:amount],
      from_wallet: @current_user.wallet,
      description: params[:description]
    )

    if Transaction.execute_transaction(transaction)
      render json: {
        message: I18n.t('transaction.messages.created', type: 'Withdrawal'),
        new_balance: @current_user.wallet.balance&.to_f
      }, status: :created
    else
      render json: { error: transaction.errors.full_messages.first }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid
    render json: { error: transaction.errors.full_messages.first }, status: :unprocessable_entity
  end

  def transfer
    to_wallet = Wallet.find(params[:to_wallet_id])

    transaction = Transactions::Transfer.new(
      amount: params[:amount],
      from_wallet: @current_user.wallet,
      to_wallet: to_wallet,
      description: params[:description]
    )

    if Transaction.execute_transaction(transaction)
      render json: {
        message: I18n.t('transaction.messages.created', type: 'Transfer'),
        new_balance: @current_user.wallet.balance&.to_f
      }, status: :created
    else
      render json: { error: transaction.errors.full_messages.first }, status: :unprocessable_entity
    end
  end

  private

  def initial_wallet
    @current_user.create_wallet if @current_user.wallet.nil?
  end
end
