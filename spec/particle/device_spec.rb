require 'helper'

describe Particle::Device do
  let(:device) { Particle.device(dev_id) }

  describe "Particle.device" do
    it "creates a Device" do
      expect(Particle.device("abc").name).to eq("abc")
    end
  end

  describe ".attributes", :vcr do
    it "returns attributes" do
      expect(device.attributes).to be_kind_of Hash
    end

    it "includes details like functions and platform" do
      expect(device.functions).to be_kind_of Array
      expect(device.platform).to be_kind_of Particle::Platform
    end
  end

  describe '.product', :vcr do
    context 'device is part of user defined product' do
      it 'returns a Product instance' do
        expect(device.product).to be_kind_of Particle::Product
      end
    end

    context 'device is not part of user defined product' do
      it 'sets the product string' do
        expect(%w[Core Photon Electron]).to include(device.product)
      end
    end
  end

  describe ".claim", :vcr do
    it "claims the device" do
      # Remove device before test
      device.remove

      expect(device.claim.id).to eq(dev_id)
    end
  end

  describe ".remove", :vcr do
    it "removes the device" do
      expect(device.remove).to eq true

      # Claim device back after test
      device.claim
    end
  end

  describe ".rename", :vcr do
    it "renames the device" do
      expect(device.rename("fried")).to eq true
    end
  end

  describe ".function", :vcr do
    it "call the function on the device firmware" do
      # Test device must have a method called "toggle" returning 1
      expect(device.function("toggle")).to eq 1
    end
  end

  describe ".variable", :vcr do
    it "gets the value of the firmware variable" do
      # Test device must have a variable called "answer" returning an integer
      expect(device.variable("answer")).to eq 42
    end
  end

  describe ".ping", :vcr do
    it "returns true for a device online" do
      expect(device.ping).to eq true
    end
  end

  describe ".signal", :vcr do
    it "starts shouting rainbows" do
      expect(device.signal).to eq true

      # Stop shouting
      device.signal(false)
    end
  end

  describe ".flash", :vcr do
    let(:source_file) { fixture("good_code.ino") }

    it "starts flashing succesfully" do
      result = device.flash(source_file)
      expect(result.ok).to eq true
      wait_for_end_of_flash
    end
  end

  describe ".compile", :vcr do
    let(:source_file) { fixture("good_code.ino") }

    it "compiles succesfully" do
      result = device.compile(source_file)
      expect(result.ok).to eq true
    end
  end

  describe ".update_public_key", :vcr do
    let(:public_key) { IO.read(fixture("device.pub.pem")) }

    it "sends the key" do
      result = device.update_public_key(public_key)
      expect(result).to eq true
    end
  end
end
