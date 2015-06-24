module Particle

  # Domain model for one Particle device
  class Device
    def self.list_path
      "v1/devices"
    end

    def self.claim_path
      "v1/devices"
    end

    attr_reader :id

    def initialize(client, id, attributes = nil)
      @client = client
      @id = id
      @attributes = attributes
    end

    def attributes
      @attributes ||= get_attributes
    end

    def get_attributes

    end

    # Add a Particle device to your account
    # Delegates the implementation to the client
    def claim
      new_device = @client.claim_device(self)
      @id = new_device.id
      self
    end

    def path
      "/v1/devices/#{id}"
    end
  end
end

