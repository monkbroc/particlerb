## particlerb ##

[![Gem Version](https://badge.fury.io/rb/particlerb.svg)](http://badge.fury.io/rb/particlerb)
[![Build Status](https://travis-ci.org/monkbroc/particlerb.svg)](https://travis-ci.org/monkbroc/particlerb)
[![Code Climate](https://codeclimate.com/github/monkbroc/particlerb/badges/gpa.svg)](https://codeclimate.com/github/monkbroc/particlerb)

Ruby client for the [Particle.io] Cloud API with an object-oriented interface

[Particle.io]: https://www.particle.io

*Note: this is not an official gem by Particle. It is maintained by Julien Vanier.*

## Installation

```
# Install via Rubygems
$ gem install particlerb

# or add to your Gemfile
gem "particlerb", "~> 0.0.3"

# Require the gem
require 'particle'
```


### Providing credentials

**A Particle cloud API access token is necessary for most requests.** You can use the one from the [Web IDE][] for testing, but it's recommended to generate a new token with this gem using `Particle.login` or with the [Particle CLI][] using `particle token new`

```ruby
# Provide acess token as an environment variable
ENV['PARTICLE_ACCESS_TOKEN']

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
# This is equivalent to
Particle.client.devices

# Or used a newly created client
client = Particle::Client.new
# Fetch the list of devices
client.devices
```

When using this gem in a multi-threaded program like a Rails application running on the puma server, it's safer to use `Particle::Client.new` in each thread rather than using the global  `Particle.client`.

[Web IDE]: http://docs.particle.io/core/build/#flash-apps-with-particle-build-account-information
[Particle CLI]: http://docs.particle.io/core/cli

## Interacting with devices

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

Change the product id. The meaning of the product id is specific to your application and account.

```ruby
Particle.device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d').change_product(3)
```

See the [Particle Cloud API documentation about devices][device docs] for more details.

[device docs]: http://docs.particle.io/core/api/#introduction-device-information

## Interacting with events

Publish an event to your devices. Returns true on success.

```ruby
Particle.publish(name: "wakeup")
Particle.publish(name: "server_ip", data: "8.8.8.8", ttl: 3600, private: true)
```

Data, ttl and private are optional.

Data is converted to JSON if it is a Hash or an Array, otherwise it is converted to a String.

See the [Particle Cloud API documentation about publishing events][publish docs] for more details.

[publish docs]: http://docs.particle.io/core/api/#publishing-events

### Limitation: Subscribe not supported

This gem does not support subscribing (listening) to events from devices.

This would require an HTTP client that supports streaming responses which is not common in Ruby. Some clients like EM-HTTP-Request do support streaming responses, but are tied to specific architectures like EventMachine.

For web server applications, webhooks are better suited to process incoming events.

## Interacting with webhooks

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

Currently the available options are:

* event
* url
* deviceid
* requestType
* headers
* json
* query
* auth
* mydevices
* rejectUnauthorized


See the [Particle Cloud API documentation about webhooks][webhook docs] for more details.

[webhook docs]: http://docs.particle.io/core/webhooks/
[webhook options]: http://docs.particle.io/core/webhooks/#webhook-options

## Authentication

Replace the access token on a client

```ruby
Particle.access_token = 'f1d52ea0de921fad300027763d8c5ebd03b1934d'

# On client instance
client = Particle::Client.new
client.access_token = 'f1d52ea0de921fad300027763d8c5ebd03b1934d'
```

**All these following methods requires the account username (email) and password.**

List all tokens that can be used to access an account. Returns an `Array` of `Particle::Token`

```ruby
Particle.tokens("me@example.com", "pa$$w0rd")
```

Log in and create a new token. Returns a `Particle::Token`. This will also set the token on the client for future calls.

```ruby
Particle.login("me@example.com", "pa$$w0rd")
```

Create a token but don't set it on the client. Returns a `Particle::Token`

```ruby
Particle.token.create("me@example.com", "pa$$w0rd")
```

`login` and `token.create` take an optional hash of options.

* `expires_in`: number of seconds that the token will be valid
* `expires_at`: `Date` when the token will become invalid

Invalidate and delete a token. Returns true on success.

```ruby
Particle.token('f1d52ea0de921fad300027763d8c5ebd03b1934d').remove("me@example.com", "pa$$w0rd")
Particle.tokens.first.remove("me@example.com", "pa$$w0rd")
```

See the [Particle Cloud API documentation about authentication and token][authentication docs] for more details.

[authentication docs]: http://docs.particle.io/core/api/#introduction-authentication

## Compiling and flashing

Flash new firmware from source. Returns a result struct

```ruby
result = device.flash('blink_led.ino')
result.ok # ==> true

result = device.flash('bad_code.ino')
result.ok # ==> false
result.errors # ==> "Compiler errors\n...\n"

device.flash(Dir.glob('firmware/*') # all files in a directory
device.flash('application.bin', binary: true)
```

Compile firmware for a specific device, platform or product. Returns a result struct

```ruby
result = device.compile('blink_led.ino')
result.ok # ==> true
result.binary_id # ==> "559061e16b4ba27e4602c5c8"

Particle.compile_code(Dir.glob('firmware/*', platform: :core) # or :photon
Particle.compile_code(Dir.glob('firmware/*', product_id: 1) # meaning depends on your account
```

Download a compiled binary. Returns the result bytes

```ruby
result = device.compile('blink_led.ino')
binary = Particle.download_binary(result.binary_id)
File.new('application.bin', 'w') { |f| f.write(binary) }
```

See the [Particle Cloud API documentation about firmware][firmware docs] for more details.

[firmware docs]: http://docs.particle.io/core/api/#basic-functions-verifying-and-flashing-new-firmware


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

This gem uses the Faraday HTTP client library, so API call may raise `Faraday::ClientError` for things like SSL errors, DNS errors, HTTP connection timed out.

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
