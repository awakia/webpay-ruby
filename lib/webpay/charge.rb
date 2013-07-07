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

    def update_attributes(attributes)
      new_object = ResponseConverter.new.convert(attributes)
      raise "unexpected object" unless new_object.is_a?(Charge)
      @attributes = new_object.attributes
    end
  end
end
