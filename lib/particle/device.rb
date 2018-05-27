require 'particle/model'
require 'particle/platform'

module Particle

  # Domain model for one Particle device
  class Device < Model
    ID_REGEX = /^\h{24}$/
    PLATFORM_IDS = Platform::IDS

    def initialize(client, attributes)
      super(client, attributes)

      if attributes.is_a? String
        if attributes =~ ID_REGEX
          @attributes = { id: attributes }
        else
          @attributes = { name: attributes }
        end
      else
        # Listing all devices returns partial attributes so check if the
        # device was fully loaded or not
        @fully_loaded = true if attributes.key?(:variables)
      end
    end

    def id
      get_attributes unless @attributes[:id]
      @attributes[:id]
    end

    def name
      get_attributes unless @attributes[:name]
      @attributes[:name]
    end

    def id_or_name
      @attributes[:id] || @attributes[:name]
    end

    attribute_reader :connected, :product_id, :last_heard, :last_app,
      :last_ip_address, :platform_id, :cellular, :status, :iccid,
      :imei, :current_build_target, :default_build_target, :system_firmware_version

    alias_method :connected?, :connected
    alias_method :cellular?, :cellular

    def functions
      get_attributes unless @fully_loaded
      @attributes[:functions]
    end

    def variables
      get_attributes unless @fully_loaded
      @attributes[:variables]
    end

    def _product
      @_product ||= Product.new(@client, product_id)
    end

    def platform
      @platform ||= Platform.new(@client, platform_id)
    end

    def platform_name
      platform.name
    end

    def product
      return _product unless dev_kit?

      puts <<~BUTT
        DEPRECATION WARNING:
        Using Device#product for retrieving the device's platform (i.e. 'Photon', 'Core', etc.) is deprecated; please use Device#platform_name instead (or, use Device#platform to get full platform object).
        Behavior for Device#product will change in version 2.x.x, such that devices without a user-defined product will soon return nil.
        (called from: #{caller(1..1).first})
      BUTT

      platform_name
    end

    # If the device isn't part of a Product that the user created
    # (device is for prototyping), then product_id will return the platform_id.
    def dev_kit?
      PLATFORM_IDS.include?(product_id)
    end

    def get_attributes
      @loaded = @fully_loaded = true
      @attributes = @client.device_attributes(self)
    end

    # Add a Particle device to your account
    #
    # @example Add a Photon by its id
    #   Particle.device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d').claim
    def claim
      new_device = @client.claim_device(self)
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
    alias_method :call, :function

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
    alias_method :get, :variable

    # Ping a device to see if it is online
    #
    # @return [boolean] true when online, false when offline
    def ping
      @client.ping_device(self)
    end

    # Signal the device to start blinking the RGB LED in a rainbow
    # pattern. Useful to identify a particular device.
    #
    # @param enabled [String] Whether to enable or disable the rainbow signal
    # @return [boolean] true when signaling, false when stopped
    def signal(enabled = true)
      @client.signal_device(self, enabled)
    end

    # Flash new firmware to this device from source code or
    # binary
    #
    # @param file_paths [Array<String>] File paths to send to cloud
    #                                   and flash
    # @param options [Hash] Flashing options
    #                       :binary => true to skip the compile stage
    # @return [OpenStruct] Result of flashing.
    #                :ok => true on success
    #                :errors => String with compile errors
    #
    def flash(file_paths, options = {})
      @client.flash_device(self, file_paths, options)
    end

    # Compile firmware from source code for this device
    #
    # @param file_paths [Array<String>] File paths to send to cloud
    #                                   and flash
    # @return [OpenStruct] Result of flashing.
    #                :ok => true on success
    #                :errors => String with compile errors
    #
    def compile(file_paths)
      @client.compile(file_paths, device_id: id)
    end

    # Update the public key for this device
    #
    # @param public_key [String] The public key in PEM format (default
    #                            format generated by openssl)
    # @param algorithm [String] The encryption algorithm for the key
    #                           (default rsa)
    # @return [boolean] true when successful
    def update_public_key(public_key, algorithm = 'rsa')
      @client.update_device_public_key(self, public_key, algorithm)
    end

    def self.list_path
      "v1/devices"
    end

    def self.claim_path
      "v1/devices"
    end

    def self.provision_path
      "v1/devices"
    end

    def update_keys_path
      "/v1/provisioning/#{id}"
    end

    def path
      "/v1/devices/#{id_or_name}"
    end

    def function_path(name)
      path + "/#{name}"
    end

    def variable_path(name)
      path + "/#{name}"
    end

    def ping_path
      path + "/ping"
    end
  end
end
