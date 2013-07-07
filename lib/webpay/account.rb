module WebPay
  class Account < Entity
    class << self
      def retrieve
        convert(WebPay.client.get(path))
      end

      def path
        '/account'
      end
    end
  end
end
