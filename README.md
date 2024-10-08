<p align="center"><img src="/art/bento-ruby-sdk.png" alt="Bento Ruby SDK"></p>


[![Build Status](https://travis-ci.org/bentonow/bento-rails-sdk.svg?branch=master)](https://travis-ci.org/bentonow/bento-rails-sdk)

> [!TIP]
> Need help? Join our [discord](https://discord.com/invite/ssXXFRmt5F) or email jesse@bentonow.com for personalized support.

The Bento Ruby on Rails SDK makes it quick and easy to build an excellent email marketing and automation experience in your Rails application. We provide powerful and customizable APIs that can be used out-of-the-box to track your users' behavior, manage subscribers, and send emails. We also expose low-level APIs so that you can build fully custom experiences.

Get started with our [📚 integration guides](https://docs.bentonow.com/) or [📘 browse the SDK reference](https://docs.bentonow.com/subscribers).

🐶 Battle-tested on Bento Production (we dog food this gem ourselves)!

🤝 Contributions welcome and rewarded! Add a PR request for a surprise!

Table of contents
=================

<!--ts-->
* [Features](#features)
* [Requirements](#requirements)
* [Getting started](#getting-started)
    * [Installation](#installation)
    * [Configuration](#configuration)
* [Modules](#modules)
* [DEPRECATED](#deprecated)
* [Contributing](#contributing)
* [License](#license)
<!--te-->

## Features

* **Simple event tracking**: We make it easy for you to track user events and behavior in your application.
* **Subscriber management**: Easily add, update, and remove subscribers from your Bento account.
* **Custom fields**: Track and update custom fields for your subscribers to store additional data.
* **Email sending**: Send both regular and transactional emails directly through the SDK.
* **Batch operations**: Perform bulk imports of subscribers and events for efficient data management.
* **Spam checking**: Validate email addresses and check for risky emails.

## Requirements

The Bento Ruby SDK requires Ruby 2.6+ due to its dependency on [Faraday](https://lostisland.github.io/faraday/#/).

Bento Account for a valid **SITE_UUID**, **BENTO_PUBLISHABLE_KEY** & **BENTO_SECRET_KEY**.

## Getting started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'bento-sdk', github: "bentonow/bento-ruby-sdk", branch: "master"
```

Then, run:

```bash
$ bundle install
```

### Configuration

Configure the SDK in an initializer:

```ruby
# config/initializers/bento.rb

Bento.configure do |config|
  config.site_uuid = 'your-site-uuid'
  config.publishable_key = ENV['BENTO_PUBLISHABLE_KEY']
  config.secret_key = ENV['BENTO_SECRET_KEY']
end
```

## Modules

### Subscribers

Manage subscribers in your Bento account.

#### Find or Create a Subscriber

```ruby
subscriber = Bento::Subscribers.find_or_create_by(email: 'user@example.com')
```

#### Import or Update Subscribers in Bulk

```ruby
Bento::Subscribers.import([
  {email: 'user1@example.com', first_name: 'John'},
  {email: 'user2@example.com', last_name: 'Doe'}
])
```

#### Add a Tag

```ruby
Bento::Subscribers.add_tag(email: 'user@example.com', tag: 'new_tag')
```

#### Remove a Tag

```ruby
Bento::Subscribers.remove_tag(email: 'user@example.com', tag: 'old_tag')
```

### Events

Track events in your application.

#### Track a Basic Event

```ruby
Bento::Events.track(email: 'user@example.com', type: '$completed_onboarding')
```

#### Track an Event with Fields

```ruby
Bento::Events.track(
  email: 'user@example.com',
  type: '$completed_onboarding',
  fields: { first_name: 'John', last_name: 'Doe' },
  details: { some_data: 'some_value' }
)
```

#### Batch Track Multiple Events

```ruby
Bento::Events.import([
  {email: 'user1@example.com', type: 'Login'},
  {email: 'user2@example.com', type: 'Purchase', fields: { product: 'T-shirt' }}
])
```

### Emails

Send emails through Bento.

#### Send an Email

```ruby
Bento::Emails.send(
  to: "user@example.com",
  from: "noreply@yourdomain.com",
  subject: "Welcome to Our App, {{ visitor.first_name }}!",
  html_body: "<p>Click here to get started: {{ link }}</p>",
  personalizations: {
      link: "https://yourdomain.com/start"
  }
)
```

#### Send a Transactional Email

```ruby
Bento::Emails.send_transactional(
  to: "user@example.com",
  from: "noreply@yourdomain.com",
  subject: "Password Reset",
  html_body: "<p>Click here to reset your password: {{ reset_link }}</p>",
  personalizations: {
      reset_link: "https://yourdomain.com/reset-password"
  }
)
```

### Spam API

Check email validity and risk.

#### Check if an email is valid

```ruby
Bento::Spam.valid?('user@example.com')
```

#### Check if an email is risky

```ruby
Bento::Spam.risky?('user@example.com')
```

## DEPRECATED

The class Bento::Analytics has now been deprecated. Please only use the above Bento SDK for Ruby on Rails projects.

## Contributing

We welcome contributions! Please see our [contributing guidelines](CODE_OF_CONDUCT.md) for details on how to submit pull requests, report issues, and suggest improvements.

## License

The Bento SDK for Ruby on Rails is available as open source under the terms of the [MIT License](LICENSE.md).