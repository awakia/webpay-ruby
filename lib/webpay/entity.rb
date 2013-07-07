module WebPay
  class Entity
    class << self
      include Operations

      def convert(hash)
        converter = ResponseConverter.new
        converter.convert(hash)
      end
    end

    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def ==(other)
      other.equal?(self) || (other.instance_of?(self.class) && other.id == self.id)
    end

    def [](key)
      send(key)
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

    private
    def update_attributes(attributes)
      raise "unexpected object" if attributes['object'] != @attributes['object']
      new_object = ResponseConverter.new.convert(attributes)
      @attributes = new_object.attributes
    end
  end
end
