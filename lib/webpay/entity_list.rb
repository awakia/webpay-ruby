module WebPay
  class EntityList < Entity
    include Enumerable

    def ==(other)
      other.equal?(self) ||
        (other.instance_of?(self.class) && other.data.map(&:id) == self.data.map(&:id))
    end

    def count
      @attributes['count']
    end

    def each(&block)
      self.data.each(&block)
    end
  end
end
