module WebPay
  class ResponseConverter
    def convert(attributes)
      case attributes['object']
      when 'card'
        Card.new(attributes)
      when 'charge'
        if attributes['card']
          attributes['card'] = convert(attributes['card'])
        end
        Charge.new(attributes)
      when 'customer'
        if attributes['active_card']
          attributes['active_card'] = convert(attributes['active_card'])
        end
        Customer.new(attributes)
      when 'token'
        if attributes['card']
          attributes['card'] = convert(attributes['card'])
        end
        Token.new(attributes)
      when 'event'
        if attributes['data']
          attributes['data']['object'] = convert(attributes['data']['object'])
        end
        Event.new(attributes)
      when 'account'
        Account.new(attributes)

      when 'list'
        attributes['data'] ||= []
        attributes['data'].map! { |line| convert(line) }
        EntityList.new(attributes)
      end
    end
  end
end
