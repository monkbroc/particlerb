require 'particle/model'
module Particle
  # Domain model for one Particle Platform from the /v1/build_targets endpoint
  class Platform < Model
    IDS = {
      0 => 'Core'.freeze,
      6 => 'Photon'.freeze,
      8 => 'P1'.freeze,
      10 => 'Electron'.freeze,
      31 => 'Raspberry Pi'.freeze,
    }.freeze

    def initialize(client, attributes)
      if attributes.is_a? String
        name = attributes
        attributes = { id: self.class.id_for_name(name), name: name }
      end

      if attributes.is_a? Integer
        id = attributes
        attributes = { id: id, name: self.class.name_for_id(id) }
      end

      super(client, attributes)
    end

    def self.id_for_name(name)
      IDS.invert[name]
    end

    def self.name_for_id(id)
      IDS[id]
    end

    attribute_reader :name, :id

    # This avoids upstream magic from making .name a Symbol--keep it a string yo
    def name
      @attributes[:name].to_s
    end
  end
end
