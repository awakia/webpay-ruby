module WebPay
  class ResponseConverter
    def convert(hash)
      attributes = hash.dup
      case hash['object']
      when 'charge'
        if hash['card']
          attributes['card'] = convert(hash['card'])
        end
        Charge.new(attributes)
      when 'card'
        Card.new(attributes)
      end
    end
  end
end
