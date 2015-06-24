require 'helper'

describe Particle::Device do
  describe "Particle.device" do
    it "creates a Device" do
      expect(Particle.device("123").id).to eq("123")
    end
  end

  describe ".claim", :vcr do
    it "claims the device" do
      # Make sure test device 0 is not claimed before recording VCR
      # cassette
      device = Particle.device(test_particle_device_ids[0]).claim
      expect(device.id).to eq(test_particle_device_ids[0])
    end
  end
end

