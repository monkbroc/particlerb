require 'helper'

describe Particle::Client::Firmware, :vcr do
  let(:id) { test_particle_device_ids[0] }
  let(:source_files) { [fixture("good_code.ino")] }
  let(:multiple_source_files) { [
    fixture("code_with_lib.ino"),
    fixture("led.h"),
    fixture("led.cpp")
  ] }
  let(:bad_source_files) { [fixture("bad_code.ino")] }

  describe ".flash", :vcr do
    context "with valid code" do
      it "starts flashing succesfully" do
        result = Particle.flash(id, source_files)
        expect(result.ok).to eq true
      end
      it "starts flashing multiple files succesfully" do
        result = Particle.flash(id, multiple_source_files)
        expect(result.ok).to eq true
      end
    end
    context "with bad code" do
      it "doesn't flash" do
        result = Particle.flash(id, bad_source_files)
        expect(result.ok).to eq false
      end
      it "returns the compiler errors" do
        result = Particle.flash(id, bad_source_files)
        expect(result.errors).to be_kind_of String
      end
    end
  end
end
