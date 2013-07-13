module WebPay

  # Object for API response hash object with <code>hash['object'] = charge</code>
  class Charge < Entity
    install_class_operations :create, :retrieve, :all

    # @return [String] Relative path to API root
    # @api private
    def self.path
      '/charges'
    end

    # Refund this charge
    # @param [Hash] params request parameters
    # @option params [Integer] :amount The amount to refund. Default is all amount.
    def refund(params = {})
      update_attributes(WebPay.client.post([path, 'refund'].join('/'), params))
    end

    # @return [String] Relative path of instance to API root
    # @api private
    def path
      "/charges/#{id}"
    end
  end
end
