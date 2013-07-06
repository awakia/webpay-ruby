module WebPay
  class Entity
    class << self
      def convert(hash)
        converter = ResponseConverter.new
        converter.convert(hash)
      end
    end

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(method_name, *args, &block)
      key = method_name.to_s
      if @attributes.has_key?(key)
        @attributes[key]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @attributes.has_key?(method_name.to_s) || super
    end
  end
end
