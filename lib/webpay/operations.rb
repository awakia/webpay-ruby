module WebPay

  # This module installs collection operations to entities.
  # Some of <code>create</code>, <code>retrieve</code>, and <code>all</code> are defined as class methods.
  module Operations

    # Install selected operations
    # @api private
    def install_class_operations(*operations)
      define_create if operations.include?(:create)
      define_retrieve if operations.include?(:retrieve)
      define_all if operations.include?(:all)
    end

    # Define <code>create</code> method
    # @api private
    def define_create
      instance_eval do
        def create(params = {})
          convert(WebPay.client.post(path, params))
        end
      end
    end

    # Define <code>retrieve(id)</code> method
    # @api private
    def define_retrieve
      instance_eval do
        def retrieve(id)
          id = id.to_s
          if id.strip == ''
            raise InvalidRequestError.invalid_id(id)
          end
          convert(WebPay.client.get([path, id].join('/')))
        end
      end
    end

    # Define <code>all</code> method
    # @api private
    def define_all
      instance_eval do
        def all(params = {})
          convert(WebPay.client.get(path, params))
        end
      end
    end
  end
end
