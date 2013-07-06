require 'webpay/version'

module WebPay
  autoload(:Client, 'webpay/client')

  @api_base = 'https://api.webpay.jp'
  @api_version = '/v1'
  @api_key = nil

  class << self
    attr_accessor :api_base, :api_key
  end

  def self.ssl_ca_file
    File.join(File.dirname(File.expand_path(__FILE__)), 'data', 'ca-certificates.crt')
  end
end
