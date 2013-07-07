module WebPay
  class Event < Entity
    install_class_operations :retrieve, :all

    def self.path
      '/events'
    end

    class Data < Entity
    end
  end
end
