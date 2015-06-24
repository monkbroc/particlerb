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

    private

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        return client.send(method_name, *args, &block)
      end

      super
    end
  end
end

# Set default configuration
Particle.reset!
