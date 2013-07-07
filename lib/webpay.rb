require 'webpay/version'

module WebPay
  autoload(:Client, 'webpay/client')
  autoload(:WebPayError, 'webpay/webpay_error')
  autoload(:APIConnectionError, 'webpay/webpay_error')
  autoload(:APIError, 'webpay/webpay_error')
  autoload(:AuthenticationError, 'webpay/webpay_error')
  autoload(:CardError, 'webpay/webpay_error')
  autoload(:InvalidRequestError, 'webpay/webpay_error')
  autoload(:Entity, 'webpay/entity')
  autoload(:EntityList, 'webpay/entity_list')
  autoload(:Account, 'webpay/account')
  autoload(:Card, 'webpay/card')
  autoload(:Charge, 'webpay/charge')
  autoload(:Customer, 'webpay/customer')
  autoload(:Event, 'webpay/event')
  autoload(:Token, 'webpay/token')
  autoload(:ResponseConverter, 'webpay/response_converter')

  @api_base = 'https://api.webpay.jp'
  @api_version = '/v1'
  @api_key = nil

  class << self
    def ssl_ca_file
      File.join(File.dirname(File.expand_path(__FILE__)), 'data', 'ca-certificates.crt')
    end

    def client
      @client ||= Client.new(@api_key, @api_base, @api_version)
    end

    def api_base=(new_value)
      @api_base = new_value
      @client = nil
    end

    def api_key=(new_value)
      @api_key = new_value
      @client = nil
    end

    def api_base
      @api_base
    end

    def api_key
      @api_base
    end
  end
end
