require 'particle/model'
module Particle
  # Domain model for one Particle OAuth client
  class OAuthClient < Model
    def initialize(client, attributes)
      super(client, attributes)
    end
    attribute_reader :name, :id, :type, :redirect_uri, :secret

    # OAuth clients can't be loaded. What you see is what you get...
    def get_attributes
      @loaded = true
      @attributes
    end

    def self.list_path
      "/v1/clients"
    end

    def self.create_path
      "/v1/clients"
    end

    def path
      "/v1/clients/#{id}"
    end
  end
end

