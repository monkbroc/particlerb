require 'helper'

describe Particle::Platform do
  let(:name) { "Photon" }
  let(:platform_id) { 6 }

  shared_examples "has_accessors" do
    it "has accessors" do
      expect(platform.name).to eql(name)
      expect(platform.id).to eql(platform_id)
    end
  end

  describe "when instantiated with attributes" do
    let(:platform) { Particle.platform(name: name, id: platform_id) }

    it_behaves_like "has_accessors"
  end

  describe "when instantiated by name" do
    let(:platform) { Particle.platform(name) }

    it_behaves_like "has_accessors"
  end

  describe "when instantiated by id" do
    let(:platform) { Particle.platform(platform_id) }

    it_behaves_like "has_accessors"
  end
end
