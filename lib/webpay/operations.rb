module WebPay
  module Operations
    def install_class_operations(*operations)
      define_create if operations.include?(:create)
      define_retrieve if operations.include?(:retrieve)
      define_all if operations.include?(:all)
    end

    def define_create
      instance_eval do
        def create(params = {})
          convert(WebPay.client.post(path, params))
        end
      end
    end

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

    def define_all
      instance_eval do
        def all(params = {})
          convert(WebPay.client.get(path, params))
        end
      end
    end
  end
end
