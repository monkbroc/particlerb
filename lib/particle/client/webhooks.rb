module Particle
  class Client

    # Client methods for the Particle webhook API
    #
    # @see http://docs.particle.io/core/webhooks/
    module Webhooks

      # Create a domain model for a Particle webhook
      #
      # @param target [String, Sawyer::Resource, Webhook] A webhook id, Sawyer::Resource or {Device} object
      # @return [Webhook] A webhook object to interact with
      def webhook(target)
        if target.is_a? Webhook
          target
        elsif target.respond_to?(:to_attrs)
          Webhook.new(self, target.to_attrs)
        else
          Webhook.new(self, target.to_s)
        end
      end

      # List all Particle webhooks on the account
      #
      # @return [Array<Webhook>] List of Particle webhooks to interact with
      def webhooks
        get(Webhook.list_path).map do |resource|
          webhook(resource)
        end
      end

      # Get information about a Particle webhook
      #
      # @param target [String, Webhook] A webhook id or {Webhook} object
      # @return [Hash] The webhook attributes
      def webhook_attributes(target)
        result = get(webhook(target).path)
        result.to_attrs
      end
    end
  end
end
