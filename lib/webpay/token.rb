module WebPay
  class Token < Entity
    class << self
      def create(params = {})
        convert(WebPay.client.post('/tokens', params))
      end
      def retrieve(id)
        convert(WebPay.client.get("/tokens/#{id}"))
      end
    end
  end
end
