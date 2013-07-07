module WebPay
  class Customer < Entity
    install_class_operations :create, :retrieve, :all

    attr_accessor :updated_attributes

    def self.path
      '/customers'
    end

    def initialize(attributes)
      @updated_attributes = {}
      super(attributes)
    end

    def []=(key, value)
      send("#{key}=", value)
    end

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

    def save
      update_attributes(WebPay.client.post(path, @updated_attributes))
      @updated_attributes = {}
      self
    end

    def delete
      response = WebPay.client.delete(path)
      response['deleted']
    end

    def path
      "/customers/#{id}"
    end
  end
end
