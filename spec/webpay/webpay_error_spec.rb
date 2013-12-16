require 'spec_helper'
describe WebPay::WebPayError do
  def error_response_from_file(name)
    content = response_file('errors/' + name).read
    status = content.split(" ", 3)[1].to_i
    body = content.split("\n\n", 2).last

    described_class.from_response(status, body)
  end

  describe 'Bad Request' do
    subject(:error) { error_response_from_file('bad_request') }
    it { should be_instance_of WebPay::InvalidRequestError }
    its(:status) { should eq 400 }
    its(:type) { should eq 'invalid_request_error' }
    its(:param) { should eq 'currency' }
    its(:message) { should eq 'Missing required param: currency' }
  end

  describe 'Unauthorized' do
    subject(:error) { error_response_from_file('unauthorized') }
    it { should be_instance_of WebPay::AuthenticationError }
    its(:status) { should eq 401 }
    its(:message) { should eq 'Invalid API key provided. Check your API key is correct.' }
  end

  describe 'Card Error' do
    subject(:error) { error_response_from_file('card_error') }
    it { should be_instance_of WebPay::CardError }
    its(:status) { should eq 402 }
    its(:type) { should eq 'card_error' }
    its(:param) { should eq 'number' }
    let(:code) { should eq 'incorrect_number' }
    its(:message) { should eq 'Your card number is incorrect' }
  end

  describe 'Not Found' do
    subject(:error) { error_response_from_file('not_found') }
    it { should be_instance_of WebPay::InvalidRequestError }
    its(:status) { should eq 404 }
    its(:type) { should eq 'invalid_request_error' }
    its(:param) { should eq 'id' }
  end

  describe 'API Error' do
    subject(:error) { error_response_from_file('unknown_api_error') }
    it { should be_instance_of WebPay::APIError }
    its(:status) { should eq 500 }
    its(:type) { should eq 'api_error' }
    its(:message) { should eq 'Unknown error occurred' }
  end

  describe 'The response JSON is broken' do
    subject(:error) { error_response_from_file('broken_json') }
    it { should be_instance_of WebPay::APIConnectionError }
    its(:message) { should include 'Response JSON is broken' }
  end

  describe 'The response JSON has no "error" field' do
    subject(:error) { described_class.from_response(404, '{}') }
    it { should be_instance_of WebPay::APIConnectionError }
    its(:message) { should include 'Invalid response {}' }
  end
end
