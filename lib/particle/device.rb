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
    # @param name [String] New name for the device
    # @example Change the name of a Photon
    #   Particle.device('blue').rename('red')
    def rename(name)
      @client.rename_device(self, name)
    end

    # Call a function in the firmware of a Particle device
    #
    # @param name [String] Function to run on firmware
    # @param argument [String] Argument string to pass to the firmware function
    # @example Call the thinker digitalWrite function
    #   Particle.device('white_whale').function('digitalWrite', '0')
    def function(name, argument = "")
      @client.call_function(self, name, argument)
    end

    # Get the value of a variable in the firmware of a Particle device
    #
    # @param target [String, Device] A device id, name or {Device} object
    # @param name [String] Variable on firmware
    # @return [String, Number] Value from the firmware variable
    # @example Get the battery voltage
    #   Particle.device('mycar').variable('battery') == 12.5
    def variable(name)
      @client.get_variable(self, name)
    end

    # Signal the device to start blinking the RGB LED in a rainbow
    # pattern. Useful to identify a particular device.
    #
    # @param enabled [String] Whether to enable or disable the rainbow signal
    # @return [boolean] true when signaling, false when stopped
    def signal(enabled = true)
      @client.signal_device(self, enabled)
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

    def function_path(name)
      path + "/#{name}"
    end

    def variable_path(name)
      path + "/#{name}"
    end
  end
end

