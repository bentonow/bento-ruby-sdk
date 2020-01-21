Bento SDK for Ruby

🍱 Simple, powerful analytics for Ruby/Rails projects!

Track events, update data, record LTV and more in Ruby. Data is stored in your Bento account so you can easily research and investigate what's going on.

👋 To get personalized support, please tweet @bento or email jesse@bentonow.com!

🐶 Battle-tested on Bento Production (we dog food this gem ourselves)!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bento-sdk', github: "bentonow/bento-ruby-sdk", branch: "master"
```


## Usage

Create an initializer called `bento.rb` with the following:
```ruby
site_id = "YOUR-SITE-ID"

Bento.configure do |config|
  config.write_key = site_id
end

::Analytics = Bento::Analytics.new() # to use Analytics.track() globally across your application!
```

Or, if you fancy, just boot it up manually:
```ruby
analytics = Bento::Analytics.new(write_key: "YOUR-SITE-ID")
```

Then go wild tracking events!
```ruby
# track a single event
Analytics.track(identity: {email: "user@yourapp.com"}, event: '$action' details: {tag: "api_test"})

# update a users custom field
Analytics.track(identity: {email: "user@yourapp.com"}, event: '$update_details', custom_fields: {favourite_meal: "bento box"})

# tag a visitor
Analytics.track(identity: {email: "jesse@bentonow.com"}, event: '$tag' details: {tag: "customer"})

# track a unique event and add LTV (example below tracks $12.34 USD)
Analytics.track(identity: {email: "jesse@bentonow.com"}, event: '$payment', details: {value: {amount: 1234, currency: "USD"}, unique: {key: "unique-identifier"}})

# track a pageview server-side
Analytics.track(identity: {email: "user@yourapp.com"}, event: '$view' page: {url: "api_test", title: ""})

```


## Things to know

1. Tracking: All events must be identified. Anonymous support coming soon!
2. Tracking: Most events and indexed inside Bento within a few seconds.
3. Gem: You can stub out events by adding ENV['STUB'].
4. If you need support, just let us know!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bentonow/bento-ruby-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
