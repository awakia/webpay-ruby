require 'webmock/rspec'
require 'webpay'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.before(:each) do
    WebPay.api_key = 'fake_apikey'
    WebPay.api_base = 'http://api.example.com'
  end
end

def stub_get_request(path, file)
  stub_request(:get, 'http://api.example.com/v1' + path).
    with(headers: { 'Authorization' => 'Bearer fake_apikey' }).
    to_return(response_file(file))
end

def stub_post_request(path, file, params = {})
  stub_request(:post, 'http://api.example.com/v1' + path).
    with(headers: { 'Authorization' => 'Bearer fake_apikey' }, body: params).
    to_return(response_file(file))
end

def stub_delete_request(path, file)
  stub_request(:delete, 'http://api.example.com/v1' + path).
    with(headers: { 'Authorization' => 'Bearer fake_apikey' }).
    to_return(response_file(file))
end

def response_file(file)
  File.new(File.expand_path(File.join(__FILE__, '..', 'resources', file + '.txt')))
end
