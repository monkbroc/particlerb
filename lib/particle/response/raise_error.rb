require 'faraday'
require 'particle/error'

module Particle
  # Faraday response middleware
  module Response

    # This class raises an Particle-flavored exception based on
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = Particle::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
