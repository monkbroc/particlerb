require 'particle/device'

module Particle
  class Client

    # Client methods for the Particle device API
    #
    # @see http://docs.particle.io/core/api/#introduction-list-devices
    module Devices

      # Create a domain model for a Particle device
      #
      # @param target [String, Hash, Device] A device id, name, hash of attributes or {Device} object
      # @return [Device] A device object to interact with
      def device(target)
        if target.is_a? Device
          target
        else
          Device.new(self, target)
        end
      end

      # List all Particle devices on the account
      #
      # @return [Array<Device>] List of Particle devices to interact with
      def devices
        get(Device.list_path).map do |attributes|
          device(attributes)
        end
      end

      # Get information about a Particle device
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @return [Hash] The device attributes
      def device_attributes(target)
        get(device(target).path)
      end

      # Add a Particle device to your account
      #
      # @param target [String, Device] A device id or {Device} object.
      #                                You can't claim a device by name
      # @return [Device] A device object to interact with
      def claim_device(target)
        result = post(Device.claim_path, id: device(target).id_or_name)
        device(result[:id])
      end

      # Create a new Particle device
      #
      # @param product [String] A product id
      # @return [Device] A device object to interact with
      def provision_device(params)
        product_id = params[:product_id] or raise ArgumentError.new("product_id parameter is required")
        result = post(Device.provision_path, product_id: product_id)
        device(result[:device_id])
      end

      # Remove a Particle device from your account
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @return [boolean] true for success
      def remove_device(target)
        result = delete(device(target).path)
        result[:ok]
      end

      # Rename a Particle device in your account
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param name [String] New name for the device
      # @return [boolean] true for success
      def rename_device(target, name)
        result = put(device(target).path, name: name)
        result[:name] == name
      end

      # Call a function in the firmware of a Particle device
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param name [String] Function to run on firmware
      # @param argument [String] Argument string to pass to the firmware function
      # @return [Integer] Return value from the firmware function
      def call_function(target, name, argument = "")
        result = post(device(target).function_path(name), arg: argument)
        result[:return_value]
      end

      # Get the value of a variable in the firmware of a Particle device
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param name [String] Variable on firmware
      # @return [String, Number] Value from the firmware variable
      def get_variable(target, name)
        result = get(device(target).variable_path(name))
        result[:result]
      end

      # Signal the device to start blinking the RGB LED in a rainbow
      # pattern. Useful to identify a particular device.
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param enabled [String] Whether to enable or disable the rainbow signal
      # @return [boolean] true when signaling, false when stopped
      def signal_device(target, enabled = true)
        result = put(device(target).path, signal: enabled ? '1' : '0')
        result[:signaling]
      end

      # Change the product_id on the device.
      # Use this carefully, it will impact what updates you receive, and
      # can only be used for products that have given their permission
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param product_id [String] New product id
      # @param should_update [String] if the device should be
      #                   immediately updated after changing the product_id
      # @return [boolean] true on success
      def change_device_product(target, product_id, should_update = false)
        params = {
          product_id: product_id,
          update_after_claim: should_update
        }
        result = put(device(target).path, params)
        if result[:error] == "Nothing to do?"
          result[:ok] = false
        end
        result[:ok]
      end

      # Update the public key for a device you own
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param public_key [String] The public key in PEM format (default
      #                            format generated by openssl)
      # @param algorithm [String] The encryption algorithm for the key
      #                           (default rsa)
      # @return [boolean] true when successful
      def update_device_public_key(target, public_key, algorithm = 'rsa')
        result = post(device(target).update_keys_path,
                      deviceID: device(target).id,
                      publicKey: public_key,
                      algorithm: algorithm)
        !result.empty?
      end
    end
  end
end
