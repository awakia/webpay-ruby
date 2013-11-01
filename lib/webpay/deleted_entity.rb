module WebPay
  class DeletedEntity < Entity
    # @return [Boolean] true
    def deleted?
      true
    end
  end
end
