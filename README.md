# Bento SDK for Ruby
[![Build Status](https://travis-ci.org/bentonow/bento-ruby-sdk.svg?branch=master)](https://travis-ci.org/bentonow/bento-ruby-sdk)

🍱 Simple, powerful analytics for Ruby/Rails projects!

Track events, update data, record LTV and more in Ruby. Data is stored in your Bento account so you can easily research and investigate what's going on.

👋 To get personalized support, please tweet @bento or email jesse@bentonow.com!

🐶 Battle-tested on Bento Production (we dog food this gem ourselves)!

## Installation

**Important note:** The minimum ruby version required has been **bumped to 2.6** as that's the minimum version required by the Faraday gem, which we introduced as a dependency for this gem

Add this line to your application's Gemfile:

```ruby
gem 'bento-sdk', github: "bentonow/bento-ruby-sdk", branch: "master"
```
****

and then to fetch the gem

```bash
$ bundle
```

## Usage
First, begin by configuring an initializer

```ruby
# config/initializers/bento.rb

Bento.configure do |config|
  config.site_uuid = '123456789abcdefghijkllmnopqqrstu'
  config.publishable_key = 'p9999aaaabbbbccccddddeeeeffff'
  config.secret_key = 'sc9999aaaabbbbccccddddeeeeffffgggg'
end
```

We expect to add support for more configuration options as listed below

| Configuration Name | Default value | Description                                                                                                                                     |
| ------------------ | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `site_uuid`        | `nil`         | The Site UUID specific to your site.                                                                                                            |
| `publishable_key`  | `nil`         | The publishable key in your API.                                                                                                                |
| `secret_key`       | `nil`         | The secret key in your API.                                                                                                                     |
| `sync_strategy`    | `:threaded`   | **Coming soon** The strategy to sync data to your Bento site. Possible values are `:threaded`, `:sidekiq`, `:active_job`, `:direct`, and `nil`. |
| `log_level`        | `:warn`       | The log level for Bento related log messages. Possible values are `:debug`, `:error`, `:fatal`, `:info`, and `:warn`                            |



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bentonow/bento-ruby-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
