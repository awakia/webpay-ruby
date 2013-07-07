module WebPay
  class Customer < Entity
    class << self
      def create(params = {})
        convert(WebPay.client.post('/customers', params))
      end
      def retrieve(id)
        convert(WebPay.client.get("/customers/#{id}"))
      end
      def all(params = {})
        convert(WebPay.client.get("/customers", params))
      end
    end

    attr_accessor :updated_attributes

    def initialize(attributes)
      @updated_attributes = {}
      super(attributes)
    end

    [:description, :card, :email].each do |attr|
      define_method("#{attr}=") do |value|
        @updated_attributes[attr] = value
      end
    end

    def save
      update_attributes(WebPay.client.post("/customers/#{id}", @updated_attributes))
      @updated_attributes = {}
      self
    end

    def delete
      response = WebPay.client.delete("/customers/#{id}")
      response['deleted']
    end
  end
end
