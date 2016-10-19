require 'faraday_middleware/response_middleware'

module Particle
  # Faraday response middleware
  module Response

    # Parse response bodies as JSON with symbol keys
    class ParseJsonSymbols < FaradayMiddleware::ResponseMiddleware
      dependency do
        require 'json' unless defined?(::JSON)
      end

      define_parser do |body|
        body = body.strip
        # Workaround for body returned as a quoted string
        body = "[#{body}]" if body.match(/^".*"$/)
        ::JSON.parse(body, symbolize_names: true) unless body.empty?
      end
    end
  end
end
