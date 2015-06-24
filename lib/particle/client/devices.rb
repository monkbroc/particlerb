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
        case target
        when Device then target
        when Hash, Sawyer::Resource then Device.new(self, target.id, target)
        else Device.new(self, target.to_s)
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
      # @example Add a Photon by its id
      #   @client.claim_device('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d')
      def claim_device(target)
        result = post(Device.claim_path, id: device(target).id)
        device(result.id)
      end
    end
  end
end
