require 'helper'

describe Particle::Client::Devices do
  before do
    Particle.reset!
    Particle.configure do |config|
      config.access_token = test_particle_access_token
    end
  end

  describe ".devices" do
    it "returns all claimed Particle devices", :vcr do
      devices = Particle.devices
      expect(devices).to be_kind_of Array
    end
  end
end
