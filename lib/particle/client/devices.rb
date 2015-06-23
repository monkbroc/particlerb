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
        get "v1/devices"
      end
    end
  end
end
