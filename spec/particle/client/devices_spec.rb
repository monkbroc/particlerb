require 'helper'

describe Particle::Client::Devices do
  describe ".devices", :vcr do
    it "returns all claimed Particle devices" do
      devices = Particle.devices
      expect(devices).to be_kind_of Array
    end
  end

  describe ".claim_device", :vcr do
    context "when the device is online" do
      it "claims the device" do
        # Make sure test device 0 is not claimed before recording VCR
        # cassette
        device = Particle.claim_device test_particle_device_ids[0]
        expect(device.id).to eq(test_particle_device_ids[0])
      end
    end

    context "when the device is offline" do
      it "returns an error" do
        # Make sure test device 0 is not claimed and offline before
        # recording VCR cassette
        expect { Particle.claim_device test_particle_device_ids[0] }.
          to raise_error(Particle::NotFound)
      end
    end

    context "when device doesn't exist" do
      it "return an error" do
        expect { Particle.claim_device "123456" }.
          to raise_error(Particle::NotFound)
      end
    end
  end
end
