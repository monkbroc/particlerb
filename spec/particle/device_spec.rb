require 'helper'

describe Particle::Device do
  let(:id) { test_particle_device_ids[0] }
  let(:device) { Particle.device(id) }

  describe "Particle.device" do
    it "creates a Device" do
      expect(Particle.device("123").id).to eq("123")
    end
  end

  describe ".claim", :vcr do
    it "claims the device" do
      # Test device must not claimed before recording VCR cassette
      expect(device.claim.id).to eq(id)
    end
  end

  describe ".remove", :vcr do
    it "removes the device" do
      # Test device must be claimed before recording VCR cassette
      expect(device.remove).to eq true
    end
  end

  describe ".rename", :vcr do
    it "renames the device" do
      expect(device.rename("fiesta")).to eq true
    end
  end

  describe ".function", :vcr do
    it "call the function on the device firmware" do
      # Test device must have a method called "get" returning -2
      expect(device.function("get")).to eq -2
    end
  end

  describe ".variable", :vcr do
    it "gets the value of the firmware variable" do
      # Test device must have a variable called "result" returning a String
      expect(device.variable("result")).to eq "3600"
    end
  end

  describe ".signal", :vcr do
    it "starts shouting rainbows" do
      expect(device.signal).to eq true
    end
  end
end

