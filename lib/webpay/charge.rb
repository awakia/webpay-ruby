module WebPay
  class Charge < Entity
    class << self
      def retrieve(id)
        convert(WebPay.client.get("/charges/#{id}"))
      end
    end
  end
end
