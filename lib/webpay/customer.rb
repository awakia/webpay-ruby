module WebPay
  class Customer < Entity
    class << self
      def create(params = {})
        convert(WebPay.client.post(path, params))
      end
      def retrieve(id)
        convert(WebPay.client.get([path, id].join('/')))
      end
      def all(params = {})
        convert(WebPay.client.get(path, params))
      end
      def path
        '/customers'
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
      define_method("#{attr}") do |value|
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
