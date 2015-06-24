module Particle
  class Client

    # Methods for the Particle device API
    # @see http://docs.particle.io/core/api/#introduction-list-devices
    module Devices

      # Create a domain model for a Particle device
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @return [Device] A device object to interact with
      def device(target)
        if target.is_a? Device
          target
        elsif target.respond_to?(:id)
          Device.new(self, target.id, target)
        else
          Device.new(self, target.to_s)
        end
      end

      # List all Particle devices on the account
      #
      # @see http://docs.particle.io/core/api/#introduction-list-devices
      #
      # @return [Array<Device>] List of Particle devices to interact with
      def devices
        get(Device.list_path).map do |resource|
          Device.new(self, resource)
        end
      end

      # Add a Particle device to your account
      #
      # @param target [String, Device] A device id, name or {Device} object
      # @return [Device] A device object to interact with
      # @see http://docs.particle.io/core/api/#introduction-claim-device
      def claim_device(target)
        result = post(Device.claim_path, id: device(target).id)
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
    end
  end
end
