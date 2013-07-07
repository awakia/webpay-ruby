module WebPay
  class WebPayError < StandardError
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

    attr_reader :status, :error_response

    def initialize(message, status = nil, error_response = nil)
      @status, @error_response = status, error_response
      super(message)
    end
  end

  class APIConnectionError < WebPayError
    def initialize(message)
      super(message)
    end
  end
  class APIError < WebPayError
    attr_reader :type
    def initialize(status, error_response)
      @type = error_response['type']
      super(error_response['message'], status, error_response)
    end
  end
  class AuthenticationError < WebPayError
    def initialize(status, error_response)
      super(error_response['message'], status, error_response)
    end
  end
  class CardError < WebPayError
    attr_reader :type, :code, :param
    def initialize(status, error_response)
      @type = error_response['type']
      @code = error_response['code']
      @param = error_response['param']
      super(error_response['message'], status, error_response)
    end
  end
  class InvalidRequestError < WebPayError
    attr_reader :type, :param
    def initialize(status, error_response)
      @type = error_response['type']
      @param = error_response['param']
      super(error_response['message'], status, error_response)
    end

    def self.invalid_id(id)
      InvalidRequestError.new(nil, {
          'type' => 'invalid_request_error',
          'message' => "ID must not be empty",
          'param' => 'id' })
    end
  end
end
