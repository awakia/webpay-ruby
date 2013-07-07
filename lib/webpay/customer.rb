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

    [:description, :card, :email].each do |attr|
      define_method("#{attr}=") do |value|
        @updated_attributes[attr] = value
      end
      define_method("#{attr}") do
        @updated_attributes[attr] || @attributes[attr]
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
