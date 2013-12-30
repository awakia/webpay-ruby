require 'spec_helper'
require 'uri'

describe WebPay do
  it 'should set proxy on Faraday client from api_proxy option' do
    proxy_uri = 'http://test.example.com:8080'
    WebPay.api_proxy = proxy_uri
    expect(WebPay.client.instance_variable_get(:@conn).proxy[:uri])
      .to eq(URI.parse(proxy_uri))
  end
end
