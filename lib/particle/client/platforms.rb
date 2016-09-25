require 'particle/platform'
require 'particle/client/build_targets'
require 'ostruct'

module Particle
  class Client
    module Platforms
      # List all available Particle Hardware platforms that you can use the cloud compiler with
      #
      # @return [Array<Platform>] List of Particle Hardware platforms that have build targets you can compile sources with
      def platforms
        @platforms = []
        get(Particle::Client::BuildTargets::HTTP_PATH)[:platforms].each_pair do |platform_name, platform_id|
          @platforms << Platform.new(self, {name: platform_name, id: platform_id})
        end
        @platforms
      end

      def platform(attributes)
        if attributes.is_a? Platform
          attributes
        else
          Platform.new(self, attributes)
        end
      end
    end
  end
end
