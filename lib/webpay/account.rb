module WebPay

  # Object for API response hash object with <code>hash['object'] = account</code>
  class Account < Entity
    class << self

      # Get the account of api_key's owner
      # @return [Account] the account of api_key's owner
      def retrieve
        convert(WebPay.client.get(path))
      end

      # Clear all test data of api_key's owner
      # @return [Boolean] true if the request succeeded
      def delete_data
        response = WebPay.client.delete([path, 'data'].join('/'))
        response['deleted']
      end

      # @api private
      # @return [String] Relative path to API root: <code>'/account'</code>
      def path
        '/account'
      end
    end
  end
end
