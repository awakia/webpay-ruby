module WebPay

  # Object for API response hash object with <code>hash['object'] = customer</code>
  class Customer < Entity
    install_class_operations :create, :retrieve, :all

    # Attributes updated by assignment.
    # These attributes are sent on save.
    # Only description, card, and email are effective.
    attr_accessor :updated_attributes

    # @return [String] Relative path to API root
    # @api private
    def self.path
      '/customers'
    end

    # @api private
    def initialize(attributes)
      @updated_attributes = {}
      super(attributes)
    end

    # <code>object['key']=</code> is wrapper for <code>object.key =</code>.
    # Method call style is recommended.
    # @return [Object] Given value
    def []=(key, value)
      send("#{key}=", value)
    end

    # <code>object['key']</code> is wrapper for <code>object.key</code>.
    # Method call style is recommended.
    # @return [Object] The attribute's value
    def [](key)
      send(key)
    end

    [:description, :card, :email].each do |attr|
      define_method("#{attr}=") do |value|
        @updated_attributes[attr.to_s] = value
      end
      define_method("#{attr}") do
        @updated_attributes[attr.to_s] || @attributes[attr.to_s]
      end
    end

    # Send update request of modified attributes.
    # description, card, and email are modifiable.
    # @return [Customer] this object with attributes updated
    def save
      update_attributes(WebPay.client.post(path, @updated_attributes))
      @updated_attributes = {}
      self
    end

    # Delete this customer.
    # This operation cannot be undone.
    # @return [Boolean] true if operation succeeded
    def delete
      response = WebPay.client.delete(path)
      response['deleted']
    end

    # @return [String] Relative path of instance to API root
    # @api private
    def path
      "/customers/#{id}"
    end
  end
end
