require 'particle/device'

module Particle
  class Client

    # Client methods for the Particle device API
    #
    # @see http://docs.particle.io/core/api/#introduction-list-devices
    module Devices

      # Create a domain model for a Particle device
      #
      # @param target [String, Sawyer::Resource, Device] A device id, name, Sawyer::Resource or {Device} object
      # @return [Device] A device object to interact with
      def device(target)
        if target.is_a? Device
          target
        elsif target.respond_to?(:to_attrs)
          Device.new(self, target.to_attrs)
        else
          Device.new(self, target)
        end
      end

      # List all Particle devices on the account
      #
      # @return [Array<Device>] List of Particle devices to interact with
      def devices
        get(Device.list_path).map do |resource|
          device(resource)
        end
      end

      # Get information about a Particle device
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @return [Hash] The device attributes
      def device_attributes(target)
        result = get(device(target).path)
        result.to_attrs
      end

      # Add a Particle device to your account
      #
      # @param target [String, Device] A device id or {Device} object.
      #                                You can't claim a device by name
      # @return [Device] A device object to interact with
      def claim_device(target)
        result = post(Device.claim_path, id: device(target).id_or_name)
        device(result.id)
      end

      # Remove a Particle device from your account
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @return [boolean] true for success
      def remove_device(target)
        result = delete(device(target).path)
        result.ok
      end

      # Rename a Particle device in your account
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param name [String] New name for the device
      # @return [boolean] true for success
      def rename_device(target, name)
        result = put(device(target).path, name: name)
        result.name == name
      end

      # Call a function in the firmware of a Particle device
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param name [String] Function to run on firmware
      # @param argument [String] Argument string to pass to the firmware function
      # @return [Integer] Return value from the firmware function
      def call_function(target, name, argument = "")
        result = post(device(target).function_path(name), arg: argument)
        result.return_value
      end

      # Get the value of a variable in the firmware of a Particle device
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param name [String] Variable on firmware
      # @return [String, Number] Value from the firmware variable
      def get_variable(target, name)
        result = get(device(target).variable_path(name))
        result.result
      end

      # Signal the device to start blinking the RGB LED in a rainbow
      # pattern. Useful to identify a particular device.
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @param enabled [String] Whether to enable or disable the rainbow signal
      # @return [boolean] true when signaling, false when stopped
      def signal_device(target, enabled = true)
        result = put(device(target).path, signal: enabled ? '1' : '0')
        # FIXME: API bug. Should return HTTP 408 so result.ok wouldn't be necessary
        if result.ok == false
          false
        else
          result.signaling
        end
      end
    end
  end
end
