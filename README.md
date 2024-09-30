# Bento SDK for Ruby
[![Build Status](https://travis-ci.org/bentonow/bento-ruby-sdk.svg?branch=master)](https://travis-ci.org/bentonow/bento-ruby-sdk)

🍱 Simple, powerful analytics for Ruby/Rails projects!

Track events, update data, record LTV and more in Ruby. Data is stored in your Bento account so you can easily research and investigate what's going on.

👋 To get personalized support, please tweet @bento or email jesse@bentonow.com!

🐶 Battle-tested on Bento Production (we dog food this gem ourselves)!

## Installation

**Important note:** The minimum ruby version required is **2.6** as that's the minimum version required by the Faraday gem, which we use as a dependency.

Add this line to your application's Gemfile:

```ruby
gem 'bento-sdk', github: "bentonow/bento-ruby-sdk", branch: "master"
```

Then, to fetch the gem:

```bash
$ bundle
```

## Configuration

Configure the SDK in an initializer:

```ruby
# config/initializers/bento.rb

Bento.configure do |config|
  config.site_uuid = '123456789abcdefghijkllmnopqqrstu'
  config.publishable_key = 'p9999aaaabbbbccccddddeeeeffff'
  config.secret_key = 'sc9999aaaabbbbccccddddeeeeffffgggg'
end
```

## Optional: ActionMailer

If you would like to use ActionMailer to send your emails, [install our ActionMailer gem](https://github.com/bentonow/bento-actionmailer) separately.

## Typical Usage

```ruby
# Users signs up to your app
Bento::Events.track(email: 'test@test.com', type: '$account.signed_up', fields: { first_name: 'Jesse', last_name: 'Hanley' })

# User cancels their account
Bento::Events.track(email: 'test@test.com', type: '$account.canceled')

# Daily Cron Job to Sync Users
Bento::Subscribers.import([
  {email: 'test@bentonow.com', first_name: 'Jesse', last_name: 'Hanley', widget_count: 1000},
  {email: 'test2@bentonow.com', first_name: 'Jesse', last_name: 'Hanley', company_name: 'Tanuki Inc.'}
])
```

## Available Methods

This Ruby SDK does not contain _all_ available API methods. Please refer to the [Bento API docs](https://docs.bentonow.com/) for all available methods. This remains an opinionated SDK based on the top use cases we've found at Bento for Ruby on Rails apps.

### Subscribers

#### Find or Create a Subscriber
Perfect for quickly adding a subscriber to your Bento account or getting their information to use within your application.
```ruby
subscriber = Bento::Subscribers.find_or_create_by(email: 'test@bentonow.com')
subscriber.email
```

#### Import or Update Subscribers in Bulk
Perfect for quickly adding subscribers (or fifty) to your Bento account.
```ruby
Bento::Subscribers.import([
  {email: 'user1@example.com', first_name: 'John'},
  {email: 'user2@example.com', last_name: 'Doe'}
])
```

#### Add a Tag

```ruby
Bento::Subscribers.add_tag(email: 'test@bentonow.com', tag: 'new_tag')
```

#### Add a Tag via Event

```ruby
Bento::Subscribers.add_tag_via_event(email: 'test@bentonow.com', tag: 'event_tag')
```

#### Remove a Tag

```ruby
Bento::Subscribers.remove_tag(email: 'test@bentonow.com', tag: 'old_tag')
```

#### Add a Field

```ruby
Bento::Subscribers.add_field(email: 'test@bentonow.com', key: 'company', value: 'Acme Inc')
```

#### Remove a Field

```ruby
Bento::Subscribers.remove_field(email: 'test@bentonow.com', field: 'company')
```

#### Subscribe a User

```ruby
Bento::Subscribers.subscribe(email: 'test@bentonow.com')
```

#### Unsubscribe a User

```ruby
Bento::Subscribers.unsubscribe(email: 'test@bentonow.com')
```

#### Change a Subscriber's Email

```ruby
Bento::Subscribers.change_email(old_email: 'old@example.com', new_email: 'new@example.com')
```

### Events

#### Track a Basic Event

```ruby
Bento::Events.track(email: 'test@test.com', type: '$completed_onboarding')
```

#### Track an Event with Fields

```ruby
Bento::Events.track(
  email: 'test@test.com',
  type: '$completed_onboarding',
  fields: { first_name: 'Jesse', last_name: 'Pinkman' }, # optional
  details: { some_data: 'some_value' }  # optional
)
```

#### Track a Unique Event (such as a purchase)

```ruby
Bento::Events.track(
  email: 'test@test.com',
  type: '$purchase',
  fields: { first_name: 'Jesse' },
  details: {
    unique: { key: 'test123' },
    value: { currency: 'USD', amount: 8000 }, # in cents
  }
)
```

#### Batch Track Multiple Events

```ruby
Bento::Events.import([
  {email: 'test@bentonow.com', type: 'Login'},
  {email: 'test@bentonow.com', type: 'Purchase', fields: { first_name: 'Jesse', last_name: 'Hanley' }}
])
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bentonow/bento-ruby-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## DEPRECATED: Bento Analytics

The class Bento::Analytics has now been deprecated. Please only use the above Bento SDK for Ruby on Rails projects.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).