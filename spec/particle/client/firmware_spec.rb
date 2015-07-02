require 'helper'
require 'tempfile'

describe Particle::Client::Firmware, :vcr do
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
        result = Particle.flash_device(dev_id, source_file)
        expect(result.ok).to eq true
        wait_for_end_of_flash
      end
      it "starts flashing multiple files succesfully" do
        result = Particle.flash_device(dev_id, multiple_source_files)
        expect(result.ok).to eq true
        wait_for_end_of_flash
      end
      it "flashes a binary file succesfully", vcr: { preserve_exact_body_bytes: true } do
        result = Particle.flash_device(dev_id, binary_file)
        expect(result.ok).to eq true
        wait_for_end_of_flash
        Particle.flash_device(dev_id, source_file)
        wait_for_end_of_flash
      end
    end
    context "with bad code" do
      it "doesn't flash" do
        result = Particle.flash_device(dev_id, bad_source_file)
        expect(result.ok).to eq false
      end
      it "returns the compiler errors" do
        result = Particle.flash_device(dev_id, bad_source_file)
        expect(result.errors.join("\n")).to be_kind_of String
      end
    end
    context "when the device is offline", :offline do
      # FIXME: API bug: expected 408 TimedOut
      it "doesn't flash" do
        expect { Particle.flash_device(dev_id, source_file) }.
          to raise_error Particle::ServerError
      end
    end
  end

  describe ".compile", :vcr do
    context "with valid code" do
      it "compiles succesfully" do
        result = Particle.compile(source_file)
        expect(result.ok).to eq true
      end
      it "provides a download url" do
        result = Particle.compile(source_file)
        expect(result.binary_url).to start_with "/v1/binaries"
      end
      it "compiles multiple files succesfully" do
        result = Particle.compile(multiple_source_files)
        expect(result.ok).to eq true
      end
      it "compiles for a specific device" do
        result = Particle.compile(source_file, device_id: dev_id)
        expect(result.ok).to eq true
      end
      it "compiles for a specific platform" do
        result = Particle.compile(source_file, platform: :photon)
        expect(result.ok).to eq true
      end
    end

    context "with bad code" do
      it "doesn't compile" do
        result = Particle.compile(bad_source_file)
        expect(result.ok).to eq false
      end
      it "returns the compiler errors" do
        result = Particle.compile(bad_source_file)
        expect(result.errors.join("\n")).to be_kind_of String
      end
    end
  end

  describe ".download_binary", vcr: { preserve_exact_body_bytes: true } do
    it "downloads the binary" do
      result = Particle.compile(source_file)
      binary = Particle.download_binary(result.binary_id)
      expect(binary.length).to be > 1000
    end
  end

  it "compiles, downloads and flashes the binary", vcr: { preserve_exact_body_bytes: true } do
    result = Particle.compile(source_file)
    binary = Particle.download_binary(result.binary_id)
    file = Tempfile.new('binary')
    begin
      file.write(binary)
      Particle.flash_device(dev_id, file.path, binary: true)
      wait_for_end_of_flash
    ensure
      file.close
      file.unlink
    end
  end
end
