# Bento SDK for Ruby
[![Build Status](https://travis-ci.org/bentonow/bento-ruby-sdk.svg?branch=master)](https://travis-ci.org/bentonow/bento-ruby-sdk)

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

If you have a Rails project create an initializer called `bento.rb` with the following:
```ruby
site_uuid = "YOUR-SITE-UUID" # This is the same UUID you are provided during onboarding. You can also find it by clicking on the gear icon on the top right and visiting "Site Configuration".

# Make Analytics.track() globally available!
::Analytics = Bento::Analytics.new(write_key: site_uuid) # to use Analytics.track() globally across your application!
```

Or, if you fancy, just boot it up via:
```ruby
analytics = Bento::Analytics.new(write_key: "YOUR-SITE-ID")
```

Then go wild tracking events:
```ruby
# track a single event
analytics.track(identity: {email: "user@yourapp.com"}, event: '$action', details: {action_information: "api_test"})

# update a users custom field
analytics.track(identity: {email: "user@yourapp.com"}, event: '$update_details', custom_fields: {favourite_meal: "bento box"})

# tag a visitor
analytics.track(identity: {email: "user@yourapp.com"}, event: '$tag', details: {tag: "customer"})

# track a unique event and add LTV (example below tracks $12.34 USD)
analytics.track(identity: {email: "user@yourapp.com"}, event: '$payment', details: {value: {amount: 1234, currency: "USD"}, unique: {key: 123456}})

# track a pageview server-side
analytics.track(identity: {email: "user@yourapp.com"}, event: '$view', page: {url: "api_test", title: ""})

```

If you're worried about having an external API in the middle of a critical path, throw it in a Sidekiq background job:
```ruby
class BentoAnalyticsJob
  include Sidekiq::Job
  queue_as :default

  def perform(email, event_type, event_details = {}, custom_fields = {})
    event_details = JSON.parse(event_details)
    custom_fields = JSON.parse(custom_fields)

    
    ::BentoAnalytics.track(
      identity: {
        email: email
      },
      event: event_type,
      details: event_details,
      custom_fields: custom_fields
    )
  end
end
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
