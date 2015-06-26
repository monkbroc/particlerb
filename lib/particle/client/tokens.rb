require 'particle/token'
require 'uri'

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
        http_options = {
          username: username,
          password: password
        }
        request(:get, Token.list_path, "", http_options).map do |resource|
          token(resource)
        end
      end

      # Authenticate with Particle and create a new token
      #
      # @param username [String] The username (email) used to log in to
      #                          the Particle Cloud API
      # @param password [String] The password used to log in to
      #                          the Particle Cloud API
      # @return [Token] The token object
      def create_token(username, password, options = {})
        data = URI.encode_www_form({
          grant_type: 'password',     # specified by docs
          username: username,
          password: password
        }.merge(options))
        http_options = {
          headers: { content_type: "application/x-www-form-urlencoded" },
          username: 'particle', # specified by docs
          password: 'particle'  # specified by docs
        }
        result = request(:post, Token.create_path, data, http_options)
        token(result)
      end

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
