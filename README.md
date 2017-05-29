# Shippingeasy Integration

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

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
| /send_orders | Send the given orders to Shipping Easy|

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shippingeasy_integration'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shippingeasy_integration

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shippingeasy_integration.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
