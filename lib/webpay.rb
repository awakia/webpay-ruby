require 'webpay/version'

# Toplevel module of WebPay gem.
# This is the start point.
module WebPay
  autoload(:Client, 'webpay/client')
  autoload(:Operations, 'webpay/operations')
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
    # Absolute path to SSL CA file.
    # This gem includes SSL CA file as lib/data/ca-certificates.crt.
    def ssl_ca_file
      File.join(File.dirname(File.expand_path(__FILE__)), 'data', 'ca-certificates.crt')
    end

    # Current client object.
    # client is memoized, and nullified when @api_base or @api_key is modified.
    def client
      @client ||= Client.new(@api_key, @api_base, @api_version)
    end

    # Set api_base, the base URL of API.
    # Configure this before sending any request.
    # Take care when using unofficial WebPay API.
    def api_base=(new_value)
      @api_base = new_value
      @client = nil
    end

    # Set api_key, your token for accessing API.
    # Configure this before sending any request.
    def api_key=(new_value)
      @api_key = new_value
      @client = nil
    end

    # Get current api_base
    def api_base
      @api_base
    end

    # Get current api_key
    def api_key
      @api_key
    end
  end
end
