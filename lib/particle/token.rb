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

    def self.list_path
      "v1/access_tokens"
    end

    def self.create_path
      "/oauth/token"
    end

    # # Add a Particle webhook
    # def create
    #   new_webhook = @client.create_webhook(@attributes)
    #   @attributes = new_webhook.attributes
    #   self
    # end

    # # Remove a Particle webhook
    # def remove
    #   @client.remove_webhook(self)
    # end

    # def self.create_path
    #   "v1/webhooks"
    # end

    # def path
    #   "/v1/webhooks/#{id}"
    # end
  end
end

