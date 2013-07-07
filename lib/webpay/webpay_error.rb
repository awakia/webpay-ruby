module WebPay

  # Abstract error class for WebPay errors.
  # All WebPay error classes inherit this.
  # This error itself is not raised.
  class WebPayError < StandardError
    # Internal
    def self.from_response(status, body)
      hash = JSON.load(body)
      unless hash['error']
        return APIConnectionError.new("Invalid response #{body}")
      end
      case status
      when 400, 404
        InvalidRequestError.new(status, hash)
      when 401
        AuthenticationError.new(status, hash)
      when 402
        CardError.new(status, hash)
      else
        APIError.new(status, hash)
      end
    end

    # @return [Integer, nil] HTTP status code
    attr_reader :status

    # @return [Hash, nil] Responded error object
    attr_reader :error_response

    def initialize(message, status = nil, error_response = nil)
      @status, @error_response = status, error_response
      super(message)
    end
  end

  # This error is raised when API request fails.
  class APIConnectionError < WebPayError
    # Internal
    def self.faraday_error(e)
      new("Connection with WebPay API server failed. #{e.message}", e)
    end

    # @return [Error] The original error raised in request
    attr_reader :original_error

    def initialize(message, original_error)
      @original_error = original_error
      super(message)
    end
  end

  # This error means WebPay service reported internal server error.
  class APIError < WebPayError

    # @return [String] 'api_error' or 'processing_error'
    attr_reader :type

    def initialize(status, error_response)
      @type = error_response['type']
      super(error_response['message'], status, error_response)
    end
  end

  # Occurs when api_key is invalid.
  # Check again that a correct api_key is set
  class AuthenticationError < WebPayError
    def initialize(status, error_response)
      super(error_response['message'], status, error_response)
    end
  end

  # Occurs when card information is invalid
  class CardError < WebPayError

    # @return [String] 'card_error'
    attr_reader :type

    # @return [String] Error code
    attr_reader :code

    # @return [String] The field where an error is detected
    attr_reader :param

    def initialize(status, error_response)
      @type = error_response['type']
      @code = error_response['code']
      @param = error_response['param']
      super(error_response['message'], status, error_response)
    end
  end

  # Occurs when the specified entity is not found, or request parameters are
  # invalid
  class InvalidRequestError < WebPayError

    # @return [String] 'invalid_request_error'
    attr_reader :type

    # @return [String] The field where an error is detected
    attr_reader :param

    def initialize(status, error_response)
      @type = error_response['type']
      @param = error_response['param']
      super(error_response['message'], status, error_response)
    end

    # Internal
    def self.invalid_id(id)
      InvalidRequestError.new(nil, {
          'type' => 'invalid_request_error',
          'message' => "ID must not be empty",
          'param' => 'id' })
    end
  end
end
