## particlerb ##

[![Gem Version](https://badge.fury.io/rb/particlerb.svg)](http://badge.fury.io/rb/particlerb)
[![Build Status](https://travis-ci.org/monkbroc/particlerb.svg)](https://travis-ci.org/monkbroc/particlerb)
[![Code Climate](https://codeclimate.com/github/monkbroc/particlerb/badges/gpa.svg)](https://codeclimate.com/github/monkbroc/particlerb)

Ruby client for the [Particle.io] Cloud API with an object-oriented interface

[Particle.io]: https://www.particle.io

*Note: this is not an official gem by Particle. It is maintained by Julien Vanier.*

## Installation

Install via Rubygems

    gem install particlerb

... or add to your Gemfile

    gem "particlerb", "~> 0.0.2"


### Providing credentials

**A Particle cloud API access token is necessary for most requests.** You can use the one from the [Web IDE][] for testing, but it's recommended to generate a new token with this gem using `Particle.login` or with the [Particle CLI][] using `particle token new`

```ruby
# Provide acess token as an environment variable
# ENV['PARTICLE_ACCESS_TOKEN']

# Or configure global authentication credentials
# If you use Rails, you can put this in config/initializers/particle.rb
Particle.configure do |c|
  c.access_token = "38bb7b318cc6898c80317decb34525844bc9db55"
end

# Or pass access token when creating a client
# If no token is passed to Particle::Client.new, the global or environment one is used
client = Particle::Client.new(access_token: "38bb7b318cc6898c80317decb34525844bc9db55")
```

### Making requests

API methods are available as module methods (consuming module-level
configuration) or as client instance methods.

```ruby
# Fetch the list of devices using the global client
Particle.devices

# Or used a newly created client
client = Particle::Client.new
# Fetch the list of devices
client.devices
```

[Web IDE]: http://docs.particle.io/core/build/#flash-apps-with-particle-build-account-information
[Particle CLI]: http://docs.particle.io/core/cli

## Interacting with devices

See the [Particle Cloud API documentation][API docs] for more details.

List all devices. Rreturns an `Array` of `Particle::Device`.

```ruby
devices = Particle.devices
```

Get a `Particle::Device` by id or name.

```ruby
device = Particle.device('blue_fire')
device = Particle.device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d')
```

Get information about a device.

```ruby
device = Particle.device('blue_fire')
device.attributes     # Hash of all attributes
device.id             # ==> 'f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d'
device.name           # ==> 'blue_fire'
device.connected?     # true
device.variables      # {:myvar => "double" } or nil if not connected
device.functions      # ["myfunction"] or nil if not connected
device.get_attributes # forces refresh of all attributes from the cloud

# If you get a Device from the Particle.devices call, you will need to call
# get_attributes to get the list of functions and variables since that's not
# returned by the cloud when calling Particle.devices
device = Particle.devices.first
device.connected?     # ==> true
device.functions      # ==> nil
device.get_attributes
device.functions      # ==> ["myfunction"]
```

Claim a device by id and add it to your account. Returns a `Particle::Device`.

```ruby
Particle.device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d').claim
```

Remove a device from your account. Returns true on success.

```ruby
Particle.device('blue_fire').remove
Particle.devices.first.remove
```

Rename a device. Returns true on success.

```ruby
Particle.device('red').rename('green')
```

Call a function on the firmware with an optional `String` argument. Returns the result of running the function as as `Number`.

```ruby
Particle.device('coffeemaker').function('brew')
Particle.devices.first.function('digitalWrite', '1')
```

Get the value of a firmware variable. Returns the result as a `String` or `Number`.

```ruby
Particle.device('mycar').variable('battery') # ==> 12.33
device = Particle.device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d')
device.variable('version') # ==> "1.0.1"
```


Signal a device to start blinking the RGB LED in rainbow patterns. Returns whether the device is signaling.

```ruby
Particle.device('nyan_cat').signal(true)
```

[API docs]: http://docs.particle.io/core/api

## Interacting with events

Publish an event to your devices. Returns true on success.

```ruby
Particle.publish(name: "wakeup")
Particle.publish(name: "server_ip", data: "8.8.8.8", ttl: 3600, private: true)
```

Data, ttl and private are optional.

Data is converted to JSON if it is a Hash or an Array, otherwise it is converted to a String.

### Limitation: Subscribe not supported

This gem does not support subscribing (listening) to events from devices.

This would require an HTTP client that supports streaming responses which is not common in Ruby. Some clients like EM-HTTP-Request do support streaming responses, but are tied to specific architectures like EventMachine.

For web server applications, webhooks are better suited to process incoming events.

## Interacting with webhooks

See the [Particle webhook documentation][webhook docs] for more details.

List existing webhooks. Returns an `Array` of `Particle::Webhook`

```ruby
Particle.webhooks
```

Get info about an existing webhook by id. Returns a `Particle::Webhook`

```ruby
webhook = Particle.webhook('ffcddbd30b860ea3cadd22db')
webhook.attributes
webhook.event
webhook.url
```

Calling `attributes` will also send a test message to your webhook url and report the `response` or `error`.

```ruby
webhook.response
webhook.error

webhook = Particle.webhooks.first
webhook.get_attributes # force reloading attributes from the cloud
# get_attributes necessary to get the response when Webhook was returned from the
# Particle.webhooks() method as it doesn't do a test message on each webhook
webhook.response
```

Create a new webhook. Pass a hash of [any options accepted by the Particle Cloud API][webhook options]. Returns a `Particle::Webhook`

```ruby
Particle.webhook(event: "weather", url: "http://myserver.com/report").create
```

[webhook docs]: http://docs.particle.io/core/webhooks/
[webhook options]: http://docs.particle.io/core/webhooks/#webhook-options

## Errors

When any API error occurs, a subclass of `Particle::Error` will be raised.

The actual error classes are

- `MissingTokenError`
- `BadRequest`
- `Unauthorized`
- `Forbidden` 
- `NotFound`
- `TimedOut`
- `ServerError`

See [a description of each error on the Particle API docs][error docs].

[error docs]: http://docs.particle.io/core/api/#introduction-errors

## Advanced

All API endpoints are availble directly on the client object as method calls like `Particle.claim_device(id)` but the preferred usage is to call methods on domain objects like `Particle.device(id).claim`. See the various `Particle::Client` subclasses for more details.

### Accessing HTTP responses

While most methods return a domain object like `Device`, sometimes you may
need access to the raw HTTP response headers. You can access the last HTTP
response with `Client#last_response`:

```ruby
device   = Particle.device('123456').claim
response = Particle.last_response
headers  = response.headers
```

## Support

Open a [GitHub issue][] if you find a bug.

[Join the conversion on the awesome Particle community forums][forum] to discuss any other topic!

[GitHub issue]: https://github.com/monkbroc/particlerb/issues
[forum]: http://community.particle.io/

## Versioning

particlerb follows the [Semantic Versioning](http://semver.org/) standard.

## Thanks

This gem is heavily inspired by [Octokit][] by GitHub. I stand on the shoulder of giants. Thanks!

Octokit is copyright (c) 2009-2014 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober and licensed under the [MIT license][Octokit license].

[Octokit]: http://github.com/octokit/octokit.rb
[Octokit license]: https://github.com/octokit/octokit.rb/blob/master/LICENSE.md


## License

Copyright (c) 2015 Julien Vanier

This gem is available under the [GNU General Public License version 3][GPL-v3]

[GPL-v3]: https://github.com/monkbroc/particlerb/blob/master/LICENSE.txt
