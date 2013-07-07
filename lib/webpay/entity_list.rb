module WebPay
  class EntityList < Entity
    def ==(other)
      other.equal?(self) ||
        (other.instance_of?(self.class) && other.data.map(&:id) == self.data.map(&:id))
    end
  end
end
