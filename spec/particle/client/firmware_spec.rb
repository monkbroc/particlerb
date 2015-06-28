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

  describe ".compile_firmware", :vcr do
    context "with valid code" do
      it "compiles succesfully" do
        result = Particle.compile_code(source_file)
        expect(result.ok).to eq true
      end
      it "provides a download url" do
        result = Particle.compile_code(source_file)
        expect(result.binary_url).to start_with "/v1/binaries"
      end
      it "compiles multiple files succesfully" do
        result = Particle.compile_code(multiple_source_files)
        expect(result.ok).to eq true
      end
      it "compiles for a specific device" do
        result = Particle.compile_code(source_file, device_id: id)
        expect(result.ok).to eq true
      end
      # FIXME: Doesn't work yet
      # it "compiles for a specific platform", :vcr => { :record => :all } do
      #   result = Particle.compile_code(source_file, platform: :photon)
      #   expect(result.ok).to eq true
      # end
    end

    context "with bad code" do
      it "doesn't compile" do
        result = Particle.compile_code(bad_source_file)
        expect(result.ok).to eq false
      end
      it "returns the compiler errors" do
        result = Particle.compile_code(bad_source_file)
        expect(result.errors).to be_kind_of String
      end
    end
  end
  describe ".download_binary", vcr: { preserve_exact_body_bytes: true } do
    it "downloads the binary" do
      result = Particle.compile_code(source_file)
      binary = Particle.download_binary(result.binary_id)
      expect(binary.length).to be > 1000
    end
  end
end
