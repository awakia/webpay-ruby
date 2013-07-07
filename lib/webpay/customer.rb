module WebPay
  class Customer < Entity
    class << self
      def create(params = {})
        convert(WebPay.client.post('/customers', params))
      end
      def retrieve(id)
        convert(WebPay.client.get("/customers/#{id}"))
      end
      def all(params = {})
        convert(WebPay.client.get("/customers", params))
      end
    end
  end
end
