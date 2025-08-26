class StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    result = LatestStockPrice.price_all

    render json: result[:data], status: result[:code]
  end
end
