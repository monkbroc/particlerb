require 'helper'

describe Particle::Client::Devices do
  before do
    Particle.reset!
    Particle.configure do |config|
      config.access_token = test_particle_access_token
    end
  end

  describe ".devices", :vcr do
    it "returns all claimed Particle devices" do
      devices = Particle.devices
      expect(devices).to be_kind_of Array
    end
  end

  describe ".claim", :vcr do
    context "when the device is online" do
      it "claims the device" do
        # Make sure __PARTICLE_DEVICE_ID_2__ is not claimed before
        # recording VCR cassette
        response = Particle.claim "__PARTICLE_DEVICE_ID_2__"
        expect(response.ok).to eq(true)
      end
    end

    context "when the device is offline" do
      it "returns an error" do
        # Make sure __PARTICLE_DEVICE_ID_2__ is unclaimed and offline before
        # recording VCR cassette
        response = Particle.claim "__PARTICLE_DEVICE_ID_2__"
        expect(response.ok).to eq(false)
      end
    end

    context "when device doesn't exist" do
      it "return an error" do
        response = Particle.claim "123456"
        expect(response.ok).to eq(false)
      end
    end
  end
end
