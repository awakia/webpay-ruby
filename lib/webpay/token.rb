module WebPay
  class Token < Entity
    class << self
      def create(params = {})
        convert(WebPay.client.post(path, params))
      end
      def retrieve(id)
        convert(WebPay.client.get([path, id].join('/')))
      end
      def path
        '/tokens'
      end
    end
  end
end
