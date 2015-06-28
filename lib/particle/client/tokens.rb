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
      # @param target [String, Hash, Token] A token id, hash of attributes or {Token} object
      # @return [Token] A token object to interact with
      def token(target = {})
        if target.is_a? Token
          target
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
        request(:get, Token.list_path, "", http_options).map do |attributes|
          token(attributes)
        end
      end

      # Authenticate with Particle and create a new token
      #
      # @param username [String] The username (email) used to log in to
      #                          the Particle Cloud API
      # @param password [String] The password used to log in to
      #                          the Particle Cloud API
      # @param options [Hash] Optional Particle Cloud API options to
      #                       create the token.
      #                       :expires_in => How many seconds should the token last for?
      #                                      0 means a token that never expires
      #                       :expires_at => Date and time when should the token expire
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
        result[:token] = result.delete(:access_token)
        token(result)
      end

      # Authenticate with Particle and start using the token on the
      # client right away
      #
      # @param username [String] The username (email) used to log in to
      #                          the Particle Cloud API
      # @param password [String] The password used to log in to
      #                          the Particle Cloud API
      # @param options [Hash] Additional Particle Cloud API options to
      #                       create the token.
      # @return [Token] The token object
      def login(username, password, options = {})
        token = create_token(username, password, options)
        self.access_token = token
        token
      end

      # Remove a Particle token
      #
      # @param username [String] The username (email) used to log in to
      #                          the Particle Cloud API
      # @param password [String] The password used to log in to
      #                          the Particle Cloud API
      # @param target [String, Token] An token id or {Token} object
      # @return [boolean] true for success
      def remove_token(username, password, target)
        http_options = {
          username: username,
          password: password
        }
        result = request(:delete, token(target).path, "", http_options)
        result[:ok]
      end
    end
  end
end
