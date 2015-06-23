module Particle
  class Client

    # Methods for the Particle device API
    # @see http://docs.particle.io/core/api/#introduction-list-devices
    module Devices

      # List all Particle devices on the account
      #
      # @see http://docs.particle.io/core/api/#introduction-list-devices
      #
      # @return [Array<Sawyer::Resource>] List of Particle devices
      def devices
        get Device.list_path
      end

      # Add a Particle device to your account
      #
      # @param device [String, Device] A device id, name or {Device} object
      # @return [Sawyer::Resource] Result of claim
      # @see http://docs.particle.io/core/api/#introduction-claim-device
      # @example Add a Photon by its id
      #   @client.claim('f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d')
      def claim(device)
        post Device.claim_path, id: Particle.Device(device).id
      end
    end
  end
end
