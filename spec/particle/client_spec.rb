require 'helper'

describe Particle::Client do
  DUMMY_TOKEN = "f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d"

  before do
    Particle.reset!
  end

  describe "configuration" do
    def set_dummy_configuration_keys
      Particle.configure do |config|
        Particle::Configurable.keys.each do |key|
          config.send("#{key}=", "Dummy #{key}")
        end
      end
    end

    it "inherits the global configuration" do
      set_dummy_configuration_keys
      client = Particle::Client.new
      Particle::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Dummy #{key}")
      end
    end

    context "with instance configuration" do
      it "overrides global configuration" do
        set_dummy_configuration_keys
        opts = {
          api_endpoint: "http://www.example.com/",
          access_token: DUMMY_TOKEN,
        }
        client = Particle::Client.new(opts)
        expect(client.api_endpoint).to eq("http://www.example.com/")
        expect(client.access_token).to eq(DUMMY_TOKEN)
      end
    end

    it "masks tokens on inspect" do
      client = Particle::Client.new(access_token: DUMMY_TOKEN)
      inspected = client.inspect
      expect(inspected).not_to include(DUMMY_TOKEN)
    end
  end

  describe "authentication", :vcr do
    context "when token provided" do
      it "makes authenticated calls" do
        client = Particle::Client.new(access_token: DUMMY_TOKEN)

        authenticated_request =
          stub_request(:get, "https://api.particle.io/").
          with(headers: { authorization: "Bearer #{DUMMY_TOKEN}" })
        client.get("/")
        assert_requested authenticated_request
      end
    end
    context "when no token is provided" do
      it "raises MissingTokenError" do
        Particle.configure do |config|
          config.access_token = nil
        end
        client = Particle.client

        expect { client.get("/v1/devices") }.
          to raise_error Particle::MissingTokenError
      end
    end
  end

  describe ".last_response", :focus do
    it "makes the complete HTTP response available", :vcr do
      Particle.access_token = test_particle_access_token
      Particle.devices
      expect(Particle.last_response.headers).to be_kind_of Hash
    end
  end
end

