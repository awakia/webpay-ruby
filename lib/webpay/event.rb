module WebPay
  class Event < Entity
    class << self
      def retrieve(id)
        convert(WebPay.client.get([path, id].join('/')))
      end
      def all(params = {})
        convert(WebPay.client.get(path, params))
      end
      def path
        '/events'
      end
    end

    class Data < Entity
    end
  end
end
