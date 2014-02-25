# -*- coding: utf-8 -*-
require 'spec_helper'
require 'uri'

describe WebPay do
  it 'should set proxy on Faraday client from api_proxy option' do
    proxy_uri = 'http://test.example.com:8080'
    WebPay.api_proxy = proxy_uri
    expect(WebPay.client.instance_variable_get(:@conn).proxy[:uri])
      .to eq(URI.parse(proxy_uri))
  end

  describe 'Not Found with Accept-Language: ja' do
    let(:id) { 'cus_eS6dGfa8BeUlbS' }
    before do
      stub_request(:get, 'http://api.example.com/v1/customers/' + id).
        with(headers: { 'Authorization' => 'Bearer fake_apikey', 'Accept-Language' => 'ja' }).
        to_return(response_file('errors/not_found_ja'))
    end
    subject(:error) {
      WebPay.api_base = 'http://api.example.com/v1'
      WebPay.language = :ja
      begin
        WebPay::Customer.retrieve(id)
      rescue => e
        e
      end
    }
    it { should be_instance_of WebPay::InvalidRequestError }
    its(:status) { should eq 404 }
    its(:type) { should eq 'invalid_request_error' }
    its(:param) { should eq 'id' }
    its(:message) { should eq '該当する顧客がありません: cus_eS6dGfa8BeUlbS' }
  end
end
