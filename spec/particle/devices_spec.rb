require 'helper'

describe Particle::Client::Devices do
  before do
    Particle.reset!
  end

  describe ".devices" do
    it "returns all claimed Particle devices" do
      devices = Particle.devices
      expect(devices).to be_kind_of Array
    end
  end
end
