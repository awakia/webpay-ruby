require 'faraday'
require 'json'

module WebPay

  # API client wrapping of Faraday.
  # Not intended to use directly.
  class Client

    # Initialize client
    #
    # @param api_key [String] User's secret API key
    # @param api_base [String] the URL without trailing '/'.
    # @param api_version [String] the path indicating API version. `/v1`.
    #
    # @example Client for the default endpoint
    #     Client.new('test_secret_XXXX', 'https://api.webpay.jp', '/v1')
    def initialize(api_key, api_base, api_version, api_proxy = nil)
      ssl_options = {ca_file: WebPay.ssl_ca_file}
      default_headers = {
        'Authorization' => "Bearer #{api_key}",
        'User-Agent' => "WebPay#{api_version} RubyBinding/#{WebPay::VERSION}"
      }
      @conn = Faraday.new(api_base, ssl: ssl_options, headers: default_headers, proxy: api_proxy) do |builder|
        builder.request :url_encoded
        builder.adapter Faraday.default_adapter
      end
      @api_version = api_version
    end

    # Convert faraday response to a hash by decoding JSON.
    # This raises error if the response indicates error status.
    #
    # @api private
    # @param response [Faraday::Response]
    # @return [Hash] Raw object
    # @raise [WebPay::WebPayError] For invalid requests (4xx) or internal server error (5xx)
    def handle_response(response)
      case response.status
      when 200..299
        begin
          JSON.parse(response.body.force_encoding(infer_encoding(response)))
        rescue JSON::ParserError => e
          raise WebPay::APIConnectionError.new("Response JSON is broken. #{e.message}: #{response.body}", e)
        end
      else
        raise WebPay::WebPayError.from_response(response.status, response.body)
      end
    end

    Faraday::Connection::METHODS.each do |method|
      define_method(method) do |url, *args|
        begin
          response = @conn.__send__(method, @api_version + url, *args)
        rescue Faraday::Error::ClientError => e
          raise WebPay::APIConnectionError.faraday_error(e)
        end
        handle_response(response)
      end
    end

    private

    # Infer encoding from response
    #
    # @param response [Faraday::Response]
    # @return [Encoding]
    def infer_encoding(response)
      unless (type = response.headers['content-type']) &&
          (charset = type.split(';').find { |field| field.include?('charset=') })
        return Encoding.default_external
      end

      encoding_string = charset.split('=', 2).last.strip
      Encoding.find(encoding_string)
    rescue
      Encoding.default_external
    end
  end
end
