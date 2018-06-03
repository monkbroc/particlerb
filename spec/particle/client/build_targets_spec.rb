require 'helper'
require 'tempfile'

describe Particle::Client::BuildTargets, :vcr do
  describe ".build_targets" do
    it "returns all available build targets" do
      build_targets = Particle.build_targets
      expect(build_targets).to be_kind_of Array
      build_targets.each { |d| expect(d).to be_kind_of Particle::BuildTarget}
      expect(build_targets.length).to be >= Particle::Device::PLATFORM_IDS.keys.length, "there should be at least 1 build target for each hardware platform"
    end
  end
end
