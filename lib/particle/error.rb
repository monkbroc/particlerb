module Particle
  # Custom error class for rescuing from all Particle errors
  #
  # @see http://docs.particle.io/core/api/#introduction-errors
  class Error < StandardError

    # Returns the appropriate Particle::Error subclass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [Particle::Error]
    def self.from_response(response)
      status  = response[:status].to_i
      body    = response[:body].to_s

      if klass =  case status
                  when 400      then bad_request_error(body)
                  when 401      then Particle::Unauthorized
                  when 403      then Particle::Forbidden
                  when 404      then Particle::NotFound
                  when 408      then Particle::TimedOut
                  when 500..599 then Particle::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      @short_message = build_short_message
      super(build_error_message)
    end

    attr_reader :response
    attr_reader :short_message

    private

    def self.bad_request_error(body)
      if body =~ /access token was not found/i
        MissingTokenError
      else
        BadRequest
      end
    end

    def build_short_message
      if response && response[:body] && response[:body][:error]
        response[:body][:error]
      elsif response && response[:body] && response[:body][:errors]
        response[:body][:errors].join ", "
      else
        self.class.name
      end
    end

    def build_error_message
      return nil if response.nil?

      message =  "#{response[:method].to_s.upcase} "
      message << redact_url(response[:url].to_s) + ": "
      message << "#{response[:status]} - "
      message << "#{response[:body]}"
      message
    end

    def redact_url(url_string)
      token = "access_token"
      url_string.gsub!(/#{token}=\S+/, "#{token}=(redacted)") if url_string.include? token
      url_string
    end
  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when no authentication token is provided
  class MissingTokenError < Error; end

  # Raised when Particle returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when Particle returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when Particle returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when Particle returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when Particle returns a 408 HTTP status code
  class TimedOut < ClientError; end

  # Raised when Particle returns a 500 HTTP status code
  class ServerError < Error; end
end
