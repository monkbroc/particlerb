module Particle

  # Default configuration options for {Client}
  module Default
    API_ENDPOINT = "https://api.particle.io".freeze

    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[Particle::Configurable.keys.map { |key| [key, send(key)] }]
      end

      def api_endpoint
        ENV['PARTICLE_API_ENDPOINT'] || API_ENDPOINT
      end

      def access_token
        ENV['PARTICLE_ACCESS_TOKEN']
      end
    end
  end
end
