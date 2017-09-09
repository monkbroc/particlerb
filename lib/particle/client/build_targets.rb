require 'particle/build_target'
require 'ostruct'

module Particle
  class Client
    module BuildTargets
      # List all available Particle cloud compile build targets
      #
      # @return [Array<BuildTarget>] List of Particle Build Targets you can compile sources with
      def build_targets
        get(BuildTarget.path)[:targets].map do |target_h|
          BuildTarget.new(self, target_h)
        end
      end

      def build_target(attributes)
        if attributes.is_a? BuildTarget
          attributes
        else
          BuildTarget.new(self, attributes)
        end
      end
    end
  end
end
