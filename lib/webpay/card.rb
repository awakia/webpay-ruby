module WebPay
  class Card < Entity
    def ==(other)
      other.equals?(self) || (other.instance_of?(self.class) && other.fingerprint == self.fingerprint)
    end
  end
end
