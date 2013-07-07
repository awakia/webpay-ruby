module WebPay
  class Charge < Entity
    class << self
      def create(params = {})
        convert(WebPay.client.post(path, params))
      end
      def retrieve(id)
        convert(WebPay.client.get([path, id].join('/')))
      end
      def all(params = {})
        convert(WebPay.client.get(path, params))
      end
      def path
        '/charges'
      end
    end

    def refund(params = {})
      update_attributes(WebPay.client.post([path, 'refund'].join('/'), params))
    end

    def path
      "/charges/#{id}"
    end
  end
end
