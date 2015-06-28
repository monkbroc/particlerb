require 'helper'

describe Particle::Client::Firmware, :vcr do
  let(:id) { test_particle_device_ids[0] }
  let(:source_file) { fixture("good_code.ino") }
  let(:multiple_source_files) { [
    fixture("code_with_lib.ino"),
    fixture("led.h"),
    fixture("led.cpp")
  ] }
  let(:bad_source_file) { fixture("bad_code.ino") }
  let(:binary_file) { fixture("spark_tinker.bin") }

  describe ".flash_device", :vcr do
    context "with valid code" do
      it "starts flashing succesfully" do
        result = Particle.flash_device(id, source_file)
        expect(result.ok).to eq true
      end
      it "starts flashing multiple files succesfully" do
        result = Particle.flash_device(id, multiple_source_files)
        expect(result.ok).to eq true
      end
      it "flashes a binary file succesfully", vcr: { preserve_exact_body_bytes: true } do
        result = Particle.flash_device(id, binary_file)
        expect(result.ok).to eq true
      end
    end
    context "with bad code" do
      it "doesn't flash" do
        result = Particle.flash_device(id, bad_source_file)
        expect(result.ok).to eq false
      end
      it "returns the compiler errors" do
        result = Particle.flash_device(id, bad_source_file)
        expect(result.errors).to be_kind_of String
      end
    end
    context "when the device is offline" do
      let(:id) { test_particle_device_ids[1] }
      it "doesn't flash" do
        result = Particle.flash_device(id, source_file)
        expect(result.ok).to eq false
      end
    end
  end
end
