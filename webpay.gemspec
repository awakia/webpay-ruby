# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webpay/version'

Gem::Specification.new do |spec|
  spec.name          = 'webpay'
  spec.version       = WebPay::VERSION
  spec.authors       = ['webpay', 'tomykaira']
  spec.email         = ['administrators@webpay.jp', 'tomykaira@webpay.jp']
  spec.description   = 'WebPay is payment gateway service in Japan. see also https://webpay.jp/'
  spec.summary       = 'Ruby bindings of WebPay API'
  spec.homepage      = 'https://webpay.jp'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.8.7'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard', '~> 0.8.6.2'
  spec.add_development_dependency 'redcarpet', '~> 3.0.0'
end
