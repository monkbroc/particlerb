require 'helper'

describe Particle::BuildTarget do
  let(:version) { "0.6.0-rc.2" }
  let(:firmware_vendor) { "Particle" }
  let(:platforms) { [6] }
  let(:prereleases) { [6] }
  let(:build_target) { Particle.build_target(version: version, platforms: platforms, prereleases: prereleases, firmware_vendor: firmware_vendor) }
  it "has accessors" do
    expect(build_target.version).to eql(version)
    expect(build_target.firmware_vendor).to eql(firmware_vendor)
    expect(build_target.platforms).to eql(platforms)
    expect(build_target.prereleases).to eql(prereleases)
  end
end
