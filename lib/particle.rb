require 'particle/configurable'
require 'particle/default'
require 'particle/client'

module Particle
  class << self
    include Particle::Configurable

    def client
      return @client if @client && @client.same_options?(options)
      @client = Particle::Client.new(options)
    end
  end
end

# Set default configuration
Particle.reset!
