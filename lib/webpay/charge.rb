module WebPay
  class Charge < Entity
    install_class_operations :create, :retrieve, :all

    def self.path
      '/charges'
    end

    def refund(params = {})
      update_attributes(WebPay.client.post([path, 'refund'].join('/'), params))
    end

    def path
      "/charges/#{id}"
    end
  end
end
