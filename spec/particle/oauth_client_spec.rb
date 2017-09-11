require 'helper'

describe Particle::OAuthClient do
  describe "Particle.oauth_client" do
    it "creates an OAuthClient" do
      expect(Particle.oauth_client(name: "abc").name).to eq("abc")
    end
  end

  describe ".remove", :vcr do
    it "removes the client" do
      client = Particle.create_oauth_client(
        name: "particlerb-installed-client",
        type: "installed"
      )
      expect(client.remove).to eq true
    end
  end
end

