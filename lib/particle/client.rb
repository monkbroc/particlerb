require 'particle/connection'
require 'particle/client/devices'

module Particle

  # Client for the Particle API
  #
  # @see http://docs.particle.io/
  class Client
    include Particle::Configurable
    include Particle::Connection
    include Particle::Client::Devices

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      Particle::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Particle.instance_variable_get(:"@#{key}"))
      end
    end
  end
end
