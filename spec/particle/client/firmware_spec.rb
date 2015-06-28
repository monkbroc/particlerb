require 'helper'

describe Particle::Client::Firmware, :vcr do
  let(:id) { test_particle_device_ids[0] }
  let(:source_files) { [fixture("good_code.ino")] }
  let(:bad_source_files) { [fixture("bad_code.ino")] }

  # describe ".flash", :vcr => { record: :all } do
  #   context "with valid code" do
  #     it "starts flashing succesfully" do
  #       expect(Particle.flash(id, source_files)).to eq true
  #     end
  #   end
  #   context "with bad code" do
  #     it "returns the compiler errors" do
  #       expect(Particle.flash(id, bad_source_files)).to eq true
  #     end
  #   end
  # end
end
