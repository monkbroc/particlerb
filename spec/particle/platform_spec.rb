require 'helper'

describe Particle::Platform do
  let(:name) { "Photon" }
  let(:platform_id) { 6 }
  let(:platform) { Particle.platform(name: name, id: platform_id) }
  it "has accessors" do
    expect(platform.name).to eql(name)
    expect(platform.id).to eql(platform_id)
  end
end
