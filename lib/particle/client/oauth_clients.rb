require 'particle/oauth_client'

module Particle
  class Client

    # Client methods for the Particle OAuth client API
    #
    # @see https://docs.particle.io/reference/api/#oauth-clients
    module OAuthClients

      # Create a domain model for a Particle OAuth client
      #
      # @param target [String, Hash, OAuthClient] A client id, hash of attributes or {OAuthClient} object
      # @return [OAuthClient] A OAuth client object to interact with
      def oauth_client(target)
        if target.is_a? OAuthClient
          target
        else
          OAuthClient.new(self, target)
        end
      end

      # List all Particle OAuth clients on the account
      #
      # @return [Array<OAuthClient>] List of Particle OAuth clients to interact with
      def oauth_clients
        result = get(OAuthClient.list_path)
        result[:clients].map do |attributes|
          oauth_client(attributes)
        end
      end

      # Create a Particle OAuth client
      #
      # @param options [Hash] Options to configure the client
      # @return [OAuthClient] An OAuth client object to interact with
      def create_oauth_client(attributes)
        result = post(OAuthClient.create_path, attributes)
        oauth_client(result[:client])
      end

      # Remove a Particle OAuth client
      #
      # @param target [String, OAuthClient] A client id or {OAuthClient} object
      # @return [boolean] true for success
      def remove_oauth_client(target)
        delete(oauth_client(target).path)
        true
      end
    end
  end
end
