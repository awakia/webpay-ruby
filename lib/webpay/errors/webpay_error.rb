module WebPay
  class WebPayError < StandardError
    def self.from_response(status, body)
      new(body) # TODO
    end
  end
end
