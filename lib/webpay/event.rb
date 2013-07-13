module WebPay

  # Object for API response hash object with <code>hash['object'] = event</code>
  class Event < Entity
    install_class_operations :retrieve, :all

    # @api private
    def self.path
      '/events'
    end

    # Entity object for <code>event.data</code>
    # This entity has <code>object</code> on which event occurred,
    # and <code>previous_attributes</code> if some of attributes are modified on the event.
    class Data < Entity
    end
  end
end
