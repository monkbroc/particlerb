module Particle

  # Domain model for one Particle device
  class Device
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
    #
    # @example Add a Photon by its id
    #   Particle.device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d').claim
    def claim
      new_device = @client.claim_device(self)
      @id = new_device.id
      self
    end

    # Remove a Particle device from your account
    #
    # @example Add a Photon by its id
    #   Particle.device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d').claim
    def remove
      @client.remove_device(self)
    end

    # Rename a Particle device on your account
    #
    # @example Change the name of a Photon
    #   Particle.device('blue').rename('red')
    def rename(name)
      @client.rename_device(self, name)
    end

    def self.list_path
      "v1/devices"
    end

    def self.claim_path
      "v1/devices"
    end

    def path
      "/v1/devices/#{id}"
    end
  end
end

