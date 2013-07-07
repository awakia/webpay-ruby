module WebPay
  class Event < Entity
    class << self
      def retrieve(id)
        convert(WebPay.client.get("/events/#{id}"))
      end
      def all(params = {})
        convert(WebPay.client.get("/events", params))
      end
    end

    class Data < Entity
    end
  end
end
