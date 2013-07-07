module WebPay
  class Token < Entity
    install_class_operations :create, :retrieve

    def self.path
      '/tokens'
    end
  end
end
