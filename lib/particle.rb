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

    # Authenticate with Particle and start using the new token as the
    # global token
    #
    # Delegates actual functionality to the client.
    #
    # @param username [String] The username (email) used to log in to
    #                          the Particle Cloud API
    # @param password [String] The password used to log in to
    #                          the Particle Cloud API
    # @param options [Hash] Additional Particle Cloud API options to
    #                       create the token.
    # @return [Token] The token object
    # @see {Particle::Client::Tokens#login}
    def login(username, password, options = {})
      token = client.login(username, password, options)
      self.access_token = token.access_token
      token
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
