module Particle

  # Domain model for one Particle device
  class Device
    def self.list_path
      "v1/devices"
    end

    def self.claim_path
      "v1/devices"
    end

    attr_reader :id

    def initialize(id)
      @id = id
    end

    def path
      "/v1/devices/#{id}"
    end
  end

  # Conversion function
  def Device(value)
    case value
    when Device then value
    else Device.new(value)
    end
  end
  module_function :Device
end

