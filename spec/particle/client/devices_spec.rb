require 'helper'

describe Particle::Client::Devices, :vcr do
  describe ".devices" do
    it "returns all claimed Particle devices" do
      devices = Particle.devices
      expect(devices).to be_kind_of Array
      devices.each { |d| expect(d).to be_kind_of Particle::Device }
    end

    it "loads missing attributes from a partially loaded device" do
      device = Particle.devices.first
      expect(device.functions).to be_kind_of Array
    end
  end

  describe ".device_attributes" do
    context "when the device is online" do
      it "returns attributes" do
        attr = Particle.device_attributes(dev_id)
        expect(attr).to include(:id, :name, :connected, :variables, :functions)
        expect(attr[:connected]).to be true
        expect(attr[:variables]).to be_kind_of Hash
        expect(attr[:functions]).to be_kind_of Array
      end
    end
    context "when the device is offline", :offline do
      it "returns attributes" do
        attr = Particle.device_attributes(dev_id)
        expect(attr).to include(:id, :name, :connected, :variables, :functions)
        expect(attr[:connected]).to be false
        expect(attr[:variables]).to be_nil
        expect(attr[:functions]).to be_nil
      end
    end
    context "when device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.device_attributes("123456") }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".claim_device" do
    context "when the device is online" do
      it "claims the device" do
        Particle.remove_device(dev_id)
        expect(Particle.claim_device(dev_id).id).to eq(dev_id)
      end
    end

    context "when the device is offline", :offline do
      it "raises NotFound" do
        # Make sure test device 0 is not claimed and offline before
        # recording VCR cassette
        expect { Particle.claim_device(dev_id) }.to raise_error(Particle::NotFound)
      end
    end

    context "when device doesn't exist" do
      it "raises NotFound" do
        expect { Particle.claim_device("123456") }.to raise_error(Particle::NotFound)
      end
    end
  end

  describe ".remove_device" do
    context "when the device exists" do
      it "removes the device" do
        expect(Particle.remove_device(dev_id)).to eq true
        Particle.claim_device(dev_id)
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.remove_device("1234") }.to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".rename_device" do
    context "when the device exists" do
      it "renames the device" do
        expect(Particle.rename_device(dev_id, "fried")).to eq true
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.rename_device("1234", "blah") }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".call_function" do
    context "when the device is online" do
      context "when the function exists" do
        it "calls the function on the device firmware" do
          # Test device must have a method called "toggle" returning 1
          expect(Particle.call_function(dev_id, "toggle")).to eq 1
        end
      end

      context "when the function doesn't exist" do
        it "raises NotFound" do
          expect { Particle.call_function(dev_id, "blahblah") }.
            to raise_error(Particle::NotFound)
        end
      end
    end

    context "when the device is offline", :offline do
      # FIXME: API Bug? I expected TimedOut here
      it "raises BadRequest" do
        expect { Particle.call_function(dev_id, "toggle") }.
          to raise_error(Particle::BadRequest)
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.call_function("1234", "toggle") }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".get_variable" do
    context "when the device is online" do
      context "when the variable exists" do
        it "returns the value on the firmware variable" do
          # Test device must have a variable called "answer" returning an integer
          expect(Particle.get_variable(dev_id, "answer")).to eq 42
        end
      end

      context "when the variable doesn't exist" do
        it "raises NotFound" do
          expect { Particle.get_variable(dev_id, "blahblah") }.
            to raise_error(Particle::NotFound)
        end
      end
    end

    context "when the device is offline", :offline do
      it "raises TimedOut" do
        expect { Particle.get_variable(dev_id, "answer") }.
          to raise_error(Particle::TimedOut)
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.get_variable("1234", "answer") }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".signal_device" do
    context "when the device is online" do
      it "starts shouting rainbows" do
        expect(Particle.signal_device(dev_id, true)).to eq true
        Particle.signal_device(dev_id, false)
      end
      it "stops shouting rainbows" do
        Particle.signal_device(dev_id, true)
        expect(Particle.signal_device(dev_id, false)).to eq false
      end
    end

    context "when the device is offline", :offline do
      # FIXME: API bug. Should return HTTP 408 to raise TimedOut
      it "raises TimedOut" do
        # Test device must be offline before recording VCR cassette
        expect { Particle.signal_device(dev_id, true) }.to raise_error(Particle::ServerError)
      end
    end

    context "when the device doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.signal_device("1234", true) }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  describe ".change_device_product" do
    # FIXME: don't want to try this before figuring out what changing product_id does
    #it "works" do
    #  expect(Particle.change_device_product(dev_id, 0)).to eq true
    #end
  end

  describe ".update_device_public_key", :vcr do
    let(:public_key) { IO.read(fixture("device.pub.pem")) }

    it "sends the key" do
      result = Particle.update_device_public_key(dev_id, public_key)
      expect(result).to eq true
    end
  end
end
