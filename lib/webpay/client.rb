require 'faraday'

module WebPay
  class Client

    # Initialize client
    #
    # @param api_key [String] User's secret API key
    # @param api_base [String] the URL without trailing '/'.
    # @param api_version [String] the path indicating API version`/v1`
    #
    # @example Client for the default endpoint
    # Client.new('test_secret_XXXX', 'https://api.webpay.jp', '/v1')
    def initialize(api_key, api_base, api_version)
      ssl_options = {ca_file: WebPay.ssl_ca_file}
      default_headers = {
        'Authorization' => "Bearer #{api_key}",
        'User-Agent' => "WebPay#{api_version} RubyBinding/#{WebPay::VERSION}"
      }
      @conn = Faraday.new(api_base, ssl: ssl_options, headers: default_headers) do |builder|
        builder.request :url_encoded
        builder.adapter Faraday.default_adapter
      end
      @api_version = api_version
    end

    Faraday::Connection::METHODS.each do |method|
      define_method(method) do |url, *args|
        response = @conn.__send__(method, @api_version + url, *args)
        handle_response(response)
      end
    end
  end
end
