module Particle

  # Domain model for Particle event
  class Event
    def self.publish_path
      "v1/devices/events"
    end
  end
end

