module WebPay

  # Object for API response hash object with <code>hash['object'] = token</code>
  class Token < Entity
    install_class_operations :create, :retrieve

    # @api private
    def self.path
      '/tokens'
    end
  end
end
