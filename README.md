# particlerb
Ruby client for the Particle.io API


## Quick start

Install via Rubygems

    gem install particlerb

... or add to your Gemfile

    gem "particlerb", "~> 0.0.1"


### Making requests

[API methods][] are available as module methods (consuming module-level
configuration) or as client instance methods.

```ruby
# Provide authentication credentials
Particle.configure do |c|
  c.access_token = "38bb7b318cc6898c80317decb34525844bc9db55"
end

# Fetch the list of devices
Particle.devices
```
or

```ruby
# Provide authentication credentials
client = Particle::Client.new(access_token: "38bb7b318cc6898c80317decb34525844bc9db55")
# Fetch the list of devices
client.devices
```

[API methods]: http://monkbroc.github.io/particlerb/method_list.html


## Thanks

This gem is heavily inspired by [Octokit][]. Thanks!

Octokit is copyright (c) 2009-2014 Wynn Netherland, Adam Stacoviak, Erik Michaels-Ober and licensed under the [MIT license][Octokit license].

[Octokit]: http://github.com/octokit/octokit.rb
[Octokit license]: https://github.com/octokit/octokit.rb/blob/master/LICENSE.md