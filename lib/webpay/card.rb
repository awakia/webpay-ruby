module WebPay

  # Object for API response hash object with <code>hash['object'] = card</code>.
  # Card is not accessible as an API endpoint
  class Card < Entity

    # Check equality with rhs
    # @return [Boolean] true if rhs is the same object, or it is a Card with the same fingerprint value
    def ==(other)
      other.equals?(self) || (other.instance_of?(self.class) && other.fingerprint == self.fingerprint)
    end
  end
end
