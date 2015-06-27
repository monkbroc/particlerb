module Particle

  # Domain model for one Particle token
  class Token < Model
    def initialize(client, attributes)
      @client = client
      @attributes =
        if attributes.is_a? String
          { token: attributes }
        else
          # Consider attributes loaded when passed in through constructor
          @loaded = true
          attributes
        end
    end

    # The id of the token
    def token
      @attributes[:token]
    end
    alias_method :id, :token
    alias_method :access_token, :token

    attribute_reader :expires_at, :client

    # Tokens can't be loaded. What you see is what you get...
    def get_attributes
      @loaded = true
      @attributes
    end

    # Text representation of the token, masking the secret part
    #
    # @return [String]
    def inspect
      inspected = super

      # Only show last 4 of token, secret
      if id
        inspected = inspected.gsub! id, "#{'*'*36}#{id[36..-1]}"
      end

      inspected
    end

    # Remove a Particle token
    # @param username [String] The username (email) used to log in to
    #                          the Particle Cloud API
    # @param password [String] The password used to log in to
    #                          the Particle Cloud API
    def remove(username, password)
      @client.remove_token(username, password, self)
    end

    def self.list_path
      "v1/access_tokens"
    end

    def self.create_path
      "/oauth/token"
    end

    def path
      "/v1/access_tokens/#{access_token}"
    end
  end
end
