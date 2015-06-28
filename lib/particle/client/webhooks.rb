require 'particle/webhook'

module Particle
  class Client

    # Client methods for the Particle webhook API
    #
    # @see http://docs.particle.io/core/webhooks/
    module Webhooks

      # Create a domain model for a Particle webhook
      #
      # @param target [String, Hash, Webhook] A webhook id, hash of attributes or {Device} object
      # @return [Webhook] A webhook object to interact with
      def webhook(target)
        if target.is_a? Webhook
          target
        else
          Webhook.new(self, target)
        end
      end

      # List all Particle webhooks on the account
      #
      # @return [Array<Webhook>] List of Particle webhooks to interact with
      def webhooks
        get(Webhook.list_path).map do |attributes|
          webhook(attributes)
        end
      end

      # Get information about a Particle webhook
      #
      # The Particle cloud will send a test message to the webhook URL
      # when this is called
      #
      # @param target [String, Webhook] A webhook id or {Webhook} object
      # @return [Hash] The webhook attributes and test message response
      def webhook_attributes(target)
        get(webhook(target).path)
      end

      # Creates a new Particle webhook
      #
      # @param options [Hash] Options to configure the webhook
      # @return [Webhook] The webhook object
      # @see http://docs.particle.io/core/webhooks/#Webhook-options
      def create_webhook(options)
        result = post(Webhook.create_path, options)
        webhook(result)
      end

      # Remove a Particle webhook
      #
      # @param target [String, Webhook] A webhook id or {Webhook} object
      # @return [boolean] true for success
      def remove_webhook(target)
        result = delete(webhook(target).path)
        result[:ok]
      end
    end
  end
end
