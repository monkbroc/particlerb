require 'particle/model'
module Particle
  # Domain model for one Particle Platform from the /v1/build_targets endpoint
  class Platform < Model
    def initialize(client, attributes)
      super(client, attributes)
    end
    attribute_reader :name, :id

    # This avoids upstream magic from making .name a Symbol--keep it a string yo
    def name
      @attributes[:name].to_s
    end
  end
end

