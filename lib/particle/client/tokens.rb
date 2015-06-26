require 'particle/token'

module Particle
  class Client

    # Client methods for the Particle authentication/token API
    #
    # @see http://docs.particle.io/core/api/#introduction-authentication
    module Tokens

      # Create a domain model for a Particle token
      #
      # @param target [String, Sawyer::Resource, Token] A token id, Sawyer::Resource or {Token} object
      # @return [Token] A token object to interact with
      def token(target)
        if target.is_a? Token
          target
        elsif target.respond_to?(:to_attrs)
          Token.new(self, target.to_attrs)
        else
          Token.new(self, target)
        end
      end

      # List all Particle tokens for the account
      #
      # @param username [String] The username (email) used to log in to
      #                          the Particle Cloud API
      # @param password [String] The password used to log in to
      #                          the Particle Cloud API
      # @return [Array<Token>] List of Particle tokens
      def tokens(username, password)
        get(Token.list_path,
            username: username,
            password: password).map do |resource|
          token(resource)
        end
      end

      ## Get information about a Particle webhook
      ##
      ## The Particle cloud will send a test message to the webhook URL
      ## when this is called
      ##
      ## @param target [String, Webhook] A webhook id or {Webhook} object
      ## @return [Hash] The webhook attributes and test message response
      #def webhook_attributes(target)
      #  result = get(webhook(target).path)
      #  result.to_attrs
      #end

      ## Creates a new Particle webhook
      ##
      ## @param options [Hash] Options to configure the webhook
      ## @return [Webhook] The webhook object
      ## @see http://docs.particle.io/core/webhooks/#Webhook-options
      #def create_webhook(options)
      #  result = post(Webhook.create_path, options)
      #  webhook(result)
      #end

      ## Remove a Particle webhook
      ##
      ## @param target [String, Webhook] A webhook id or {Webhook} object
      ## @return [boolean] true for success
      #def remove_webhook(target)
      #  result = delete(webhook(target).path)
      #  result.ok
      #end
    end
  end
end
