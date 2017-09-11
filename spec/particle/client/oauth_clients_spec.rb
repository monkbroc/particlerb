require 'helper'
require 'tempfile'

describe Particle::Client::OAuthClients, :vcr do
  describe ".oauth_clients" do
    it "returns all available OAuth clients" do
      clients = Particle.oauth_clients
      expect(clients).to be_kind_of Array
      raise StandardError, "Create at least one OAuth client in your account to test this method" if clients.empty?
      clients.each { |c| expect(c).to be_kind_of Particle::OAuthClient }
    end
  end
  describe ".create_oauth_client" do
    it "creates a web client" do
      client = Particle.create_oauth_client(
        name: "particlerb-web-client",
        type: "web",
        redirect_uri: "https://example.com"
      )
      expect(client).to be_kind_of Particle::OAuthClient
      expect(client.name).to eq "particlerb-web-client"
      Particle.remove_oauth_client(client)
    end
    it "creates an installed client" do
      client = Particle.create_oauth_client(
        name: "particlerb-installed-client",
        type: "installed"
      )
      expect(client).to be_kind_of Particle::OAuthClient
      expect(client.name).to eq "particlerb-installed-client"
      Particle.remove_oauth_client(client)
    end
  end
  describe ".remove_oauth_client" do
    it "removes the client" do
      client = Particle.create_oauth_client(
        name: "particlerb-removable-client",
        type: "installed"
      )
      result = Particle.remove_oauth_client(client)
      expect(result).to eq true
    end
  end
end
