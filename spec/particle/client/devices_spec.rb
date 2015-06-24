require 'helper'

describe Particle::Client::Devices do
  let(:id) { test_particle_device_ids[0] }

  describe ".devices", :vcr do
    it "returns all claimed Particle devices" do
      devices = Particle.devices
      expect(devices).to be_kind_of Array
    end
  end

  describe ".claim_device", :vcr do
    context "when the device is online" do
      it "claims the device" do
        # Make sure test device 0 is not claimed before recording VCR cassette
        expect(Particle.claim_device(id).id).to eq(id)
      end
    end

    context "when the device is offline" do
      it "raises NotFound" do
        # Make sure test device 0 is not claimed and offline before
        # recording VCR cassette
        expect { Particle.claim_device(id) }.to raise_error(Particle::NotFound)
      end
    end

    context "when device doesn't exist" do
      it "raises NotFound" do
        expect { Particle.claim_device("123456") }.to raise_error(Particle::NotFound)
      end
    end
  end

  describe ".remove_device", :vcr do
    context "when the device exists" do
      it "removes the device" do
        # Make sure test device 0 is claimed before recording VCR cassette
        expect(Particle.remove_device(id)).to eq true
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.remove_device("1234") }.to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".rename_device", :vcr do
    context "when the device exists" do
      it "renames the device" do
        expect(Particle.rename_device(id, "fiesta")).to eq true
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.rename_device("1234", "blah") }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".call_function", :vcr do
    context "when the device is online" do
      context "when the function exists" do
        it "calls the function on the device firmware" do
          # Test device must have a method called "get" returning -2
          expect(Particle.call_function(id, "get")).to eq -2
        end
      end

      context "when the function doesn't exist" do
        it "raises NotFound" do
          expect { Particle.call_function(id, "blahblah") }.
            to raise_error(Particle::NotFound)
        end
      end
    end

    context "when the device is offline" do
      # FIXME: API Bug? I expected TimedOut here
      it "raises BadRequest" do
        # Test device must be offline before recording VCR cassette
        expect { Particle.call_function(id, "get") }.
          to raise_error(Particle::BadRequest)
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.call_function("1234", "get") }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".get_variable", :vcr do
    context "when the device is online" do
      context "when the variable exists" do
        it "returns the value on the firmware variable" do
          # Test device must have a variable called "result" returning a String
          expect(Particle.get_variable(id, "result")).to eq "3600"
        end
      end

      context "when the variable doesn't exist" do
        it "raises NotFound" do
          expect { Particle.get_variable(id, "blahblah") }.
            to raise_error(Particle::NotFound)
        end
      end
    end

    context "when the device is offline" do
      it "raises TimedOut" do
        # Test device must be offline before recording VCR cassette
        expect { Particle.get_variable(id, "result") }.
          to raise_error(Particle::TimedOut)
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.get_variable("1234", "result") }.
          to raise_error(Particle::Forbidden)
      end
    end
  end
end
