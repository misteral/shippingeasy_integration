# Shippingeasy Integration [![CircleCI](https://circleci.com/gh/misteral/shippingeasy_integration.svg?style=svg)](https://circleci.com/gh/misteral/shippingeasy_integration)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

!!!!!!!!!!!! DOCUMENTATIONS WIP !!!!!!!!!!!!!!!!!


This is an integration for use with the
[Cangaroo](https://github.com/nebulab/cangaroo) open source project.

## Connection Parameters

The following `parameters` must be setup into your
[Cangaroo](https://github.com/nebulab/cangaroo) Job:

| Name | Value |
| :----| :-----|
| api_key | ShippingEasy API Access Token (required) |
| api_secret | ShippingEasy API Token Secret (required) |

## Webhooks

The following webhooks are implemented:

| Name | Description |
| :----| :-----------|
| /send_order | Send the given order to Shipping Easy|

## Installation on rails app

Add this line to your application's `Gemfile`:

```ruby
gem 'shippingeasy_integration'
```

mount in `routes.rb`:
```
mount ShippingeasyIntegration::Server => "/shipping_easy"
```

And then execute:

    $ bundle


## Installation as hosted app

```bash
$ gem install shippingeasy_integration
$ bundle exec rackup
```

## Usage

Create cangaroo connection:
```ruby
Cangaroo::Connection.create(
  name: 'shipping_easy',
  url: 'http://localhost:5000',
  key: 'secret_key_shipping_easy',
  token: 'secret_token_shipping_easy'
)
```

Create cangaroo job:
```
 bundle exec rails g job Cangaroo::ShippingEasyCreateOrder
```

Change `/jobs/cangaroo/shipping_easy_create_order_job.rb` to:
```ruby
module Cangaroo
  class ShippingEasyCreateOrderJob < Cangaroo::Job
    connection 'shipping_easy'
    path '/create_order'
    parameters(api_key: ENV['SHIPPING_EASY_API_KEY'],
               api_secret: ENV['SHIPPING_EASY_API_SECRET'])

    def perform?
      type == 'orders'
    end
  end
end

```

Add as job `cangaroo.rb` in `config/initializer` with:
```ruby
Rails.configuration.cangaroo.jobs = [Cangaroo::ShippingEasyCreateOrderJob]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shippingeasy_integration.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
