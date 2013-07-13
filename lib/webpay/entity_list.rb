module WebPay

  # Object for API response hash object with <code>hash['object'] = list</code>.
  # This enumerates containing data.
  class EntityList < Entity
    include Enumerable

    # @return [Boolean] true if rhs is the same object or id lists of containing data are the same
    def ==(other)
      other.equal?(self) ||
        (other.instance_of?(self.class) && other.data.map(&:id) == self.data.map(&:id))
    end

    # Return the all entry count, not limited by <code>limit</code>.
    # This overrides <code>Enumerable#count</code>.  Not necessarily equal to the data size.
    def count
      @attributes['count']
    end

    # Enumerate containing data.
    def each(&block)
      self.data.each(&block)
    end
  end
end
