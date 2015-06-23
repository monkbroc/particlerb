require 'helper'

describe Particle::Client do
  TOKEN = "f8bbe1e6e69e05c9c405ba1ca504d438061f1b0d"

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
          access_token: TOKEN,
        }
        client = Particle::Client.new(opts)
        expect(client.api_endpoint).to eq("http://www.example.com/")
        expect(client.access_token).to eq(TOKEN)
      end
    end

    it "masks tokens on inspect" do
      client = Particle::Client.new(access_token: TOKEN)
      inspected = client.inspect
      expect(inspected).not_to include(TOKEN)
    end
  end

  describe "authentication" do
    def authenticated_request
      @authenticated_request ||= 
        stub_request(:get, "https://api.particle.io/").
          with(headers: { authorization: "Bearer #{TOKEN}" })
    end
    def unauthenticated_request
      @unauthenticated_request ||= 
        stub_request(:get, "https://api.particle.io/")
    end

    context "when token provided", :vcr do
      it "makes authenticated calls" do
        client = Particle.client
        client.access_token = TOKEN

        authenticated_request
        client.get("/")
        assert_requested authenticated_request
      end
    end
    context "when no token is provided" do
      it "make unauthenticated calls" do
        client = Particle.client

        unauthenticated_request
        authenticated_request
        client.get("/")
        assert_requested unauthenticated_request
        assert_not_requested authenticated_request
      end
    end
  end
end

