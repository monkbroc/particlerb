module Particle

  # Default configuration options for {Client}
  module Default
    API_ENDPOINT = "https://api.particle.io".freeze

    USER_AGENT = "particlerb Ruby gem #{Particle::VERSION}".freeze

    # TODO:
    ## # Default Faraday middleware stack
    ## MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
    ##   builder.use Octokit::Middleware::FollowRedirects
    ##   builder.use Octokit::Response::RaiseError
    ##   builder.use Octokit::Response::FeedParser
    ##   builder.adapter Faraday.default_adapter
    ## end

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

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :user_agent => user_agent
          }
        }
      end

      # Default User-Agent header string from {USER_AGENT}
      # @return [String]
      def user_agent
        USER_AGENT
      end
    end
  end
end
