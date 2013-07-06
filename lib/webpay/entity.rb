module WebPay
  class Entity
    class << self
      def convert(hash)
        converter = ResponseConverter.new
        converter.convert(hash)
      end
    end

    def initialize(attributes)
      @attributes = attributes
    end
  end
end
