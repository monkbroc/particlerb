module Particle

  # Configuration options for {Client}, defaulting to values in
  # {Default}
  module Configurable
    # @!attribute [String] access_token
    #   @see http://docs.particle.io/core/api/#introduction-authentication
    #   @return [String] Particle access token for authentication
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: https://api.particle.io
    # @!attribute connection_options
    #   @see https://github.com/lostisland/faraday
    #   @return [Hash] Configure connection options for Faraday
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.

    attr_accessor :access_token, :connection_options,
      :user_agent
    attr_writer :api_endpoint

    class << self
      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :connection_options,
          :user_agent
        ]
      end
    end

    # Yields an object to set up configuration options in an initializer
    # file
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      Particle::Configurable.keys.each do |key|
        instance_variable_set :"@#{key}", Particle::Default.options[key]
      end
    end

    # Compares client options to a Hash of requested options
    #
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    # Clever way to add / at the end of the api_endpoint
    def api_endpoint
      File.join(@api_endpoint, "")
    end

    private

    def options
      Hash[Particle::Configurable.keys.map{ |key| [key, instance_variable_get(:"@#{key}")] }]
    end
  end
end
