require 'helper'
require 'tempfile'

describe Particle::Client::Platforms, :vcr do
  describe ".platforms" do
    let(:platforms) { Particle.platforms }
    it "returns all available platforms" do
      expect(platforms).to be_kind_of Array
      platforms.each { |d| expect(d).to be_kind_of Particle::Platform }
    end
  end
end
