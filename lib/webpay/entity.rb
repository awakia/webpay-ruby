module WebPay

  # The base class for entity objects
  # @abstract
  class Entity
    class << self
      include Operations

      # Convert hash API response into an entity object
      # @param [Hash] hash Raw API response
      # @return [Entity] An entity object corresponds to hash
      def convert(hash)
        converter = ResponseConverter.new
        converter.convert(hash)
      end
    end

    # Attributes of this object.
    # <code>method_missing</code> and <code>#[]</code> are provided to access attributes
    attr_reader :attributes

    # Initialized by ResponseConverter
    # @api private
    def initialize(attributes)
      @attributes = attributes
    end

    # @return [Boolean] true if rhs is the same object or has the same id
    def ==(other)
      other.equal?(self) || (other.instance_of?(self.class) && other.id == self.id)
    end

    # Access attribute.
    # Using the attribute name as a method is recommended.
    # @return [Object] The attribute's value
    def [](key)
      send(key)
    end

    # Provide access to attributes
    # @return [Object] The attribute's value
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
      self
    end
  end
end
