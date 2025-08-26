# lib/latest_stock_price.rb
require "uri"
require "net/http"

class LatestStockPrice
  BASE_URL = ENV.fetch("RAPIDAPI_BASE_URL", "https://latest-stock-price.p.rapidapi.com")

  class << self
    def price_all
      make_request("/any")
    end

    private

    def make_request(endpoint)
      url = URI(BASE_URL + endpoint)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-key"] = ENV.fetch("RAPIDAPI_KEY", nil)
      request["x-rapidapi-host"] = ENV.fetch("RAPIDAPI_HOST", nil)

      response = http.request(request)

      if response.code == "200"
        { data: JSON.parse(response.body), code: 200 }
      else
        { data: JSON.parse(response.body), code: response.code.to_i }
      end
    rescue StandardError => e
      { data: { error: e.message }, code: 500 }
    end
  end
end
