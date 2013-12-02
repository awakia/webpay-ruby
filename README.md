# webpay-ruby [![Build Status](https://travis-ci.org/webpay/webpay-ruby.png)](https://travis-ci.org/webpay/webpay-ruby) [![Gem Version](https://badge.fury.io/rb/webpay.png)](http://badge.fury.io/rb/webpay)

WebPay Ruby bindings  https://webpay.jp

## Installation

Add this line to your application's Gemfile:

    gem 'webpay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webpay

## Usage

```ruby
require 'webpay'

WebPay.api_key = 'test_secret_YOUR_TEST_API_KEY'
WebPay::Charge.create(
   :amount=>400,
   :currency=>"jpy",
   :card=>
    {:number=>"4242-4242-4242-4242",
     :exp_month=>"11",
     :exp_year=>"2014",
     :cvc=>"123",
     :name=>"YOUR NAME"},
   :description=>"アイテムの購入"
)
```

See [WebPay Ruby API Document](https://webpay.jp/docs/api/ruby) for more details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
