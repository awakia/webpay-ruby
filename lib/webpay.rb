require 'webpay/version'

module WebPay
  @api_base = 'https://api.webpay.jp'
  @api_version = '/v1'
  @api_key = nil

  class << self
    attr_accessor :api_base, :api_key
  end
end
