require 'particle/model'
module Particle
  # Domain model for one Particle Build Target, underlying http api json looks like
  #   {
  #     "platforms": [
  #       0,
  #       8,
  #       6,
  #       10
  #     ],
  #     "prereleases": [
  #       0,
  #       8,
  #       6,
  #       10
  #     ],
  #     "firmware_vendor": "Particle",
  #     "version": "0.6.0-rc.2"
  #   },
  class BuildTarget < Model
    def initialize(client, attributes)
      super(client, attributes)
    end
    attribute_reader :platforms, :prereleases, :firmware_vendor, :version
  end
end

