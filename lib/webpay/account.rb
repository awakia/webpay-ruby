module WebPay
  class Account < Entity
    class << self
      def retrieve
        convert(WebPay.client.get('/account'))
      end
    end
  end
end
