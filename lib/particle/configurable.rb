module Particle

  # Configuration options for {Client}, defaulting to values in
  # {Default}
  module Configurable

    attr_accessor :access_token
    attr_writer :api_endpoint

    class << self
      def keys
        @keys ||= [
          :api_endpoint,
          :access_token
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

    private

    def options
      Hash[Particle::Configurable.keys.map{ |key| [key, instance_variable_get(:"@#{key}")] }]
    end
  end
end
