require 'helper'

describe Particle::Client::Publish, :vcr do
  # Make sure you have at least 1 device on your particle account to be
  # able to publish events
  describe ".publish" do
    it "publishes a public event with only a name" do
      result = Particle.publish(
        name: "test"
      )
      expect(result).to be true
    end
    it "publishes an event with data" do
      result = Particle.publish(
        name: "test",
        data: "abc"
      )
      expect(result).to be true
    end
    it "publishes an event with data hash" do
      result = Particle.publish(
        name: "test",
        data: { "abc" => "def" }
      )
      expect(result).to be true
    end
    it "publishes an event with data integer" do
      result = Particle.publish(
        name: "test",
        data: 25
      )
      expect(result).to be true
    end
    it "publishes a private event" do
      result = Particle.publish(
        name: "test",
        private: true
      )
      expect(result).to be true
    end
    it "publishes an event with all parameters" do
      result = Particle.publish(
        name: "test",
        data: "abc",
        ttl: 3600,
        private: true
      )
      expect(result).to be true
    end
  end
end
