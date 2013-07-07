module WebPay
  class Charge < Entity
    class << self
      def create(params = {})
        convert(WebPay.client.post('/charges', params))
      end
      def retrieve(id)
        convert(WebPay.client.get("/charges/#{id}"))
      end
      def all(params = {})
        convert(WebPay.client.get("/charges", params))
      end
    end

    def refund(params = {})
      update_attributes(WebPay.client.post("/charges/#{id}/refund", params))
    end
  end
end
