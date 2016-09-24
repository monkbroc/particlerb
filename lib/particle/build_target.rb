require 'particle/model'
module Particle

  # Domain model for one Particle device
  class BuildTarget < Model
    def initialize(client, attributes)
      super(client, attributes)
    end

    # attribute_reader :url, :deviceID, :event, :created_at, :mydevices,
    #   :requestType, :headers, :json, :query, :auth

    # The response of the web server to a test message
    # If nil, check error
    # def response
    #   get_attributes unless @loaded
    #   @response
    # end

    # The error from the web server to a test message
    # If nil, check response
    # def error
    #   get_attributes unless @loaded
    #   @error
    # end

    # Force reloading the attributes for the webhook
    # def get_attributes
    #   @loaded = true
    #   result = @client.webhook_attributes(self)
    #   @response = result[:response]
    #   @error = result[:error]
    #   @attributes = result[:webhook]
    # end
    #
    # Add a Particle webhook
    # def create
    #   new_webhook = @client.create_webhook(@attributes)
    #   @attributes = new_webhook.attributes
    #   self
    # end
    #
    # Remove a Particle webhook
    # def remove
    #   @client.remove_webhook(self)
    # end

    # def self.list_path
    #   "v1/webhooks"
    # end
    #
    # def self.create_path
    #   "v1/webhooks"
    # end
    #
    # def path
    #   "/v1/webhooks/#{id}"
    # end
  end
end

