require 'helper'

describe Particle do
  before do
    Particle.reset!
  end

  it "sets defaults" do
    Particle::Configurable.keys.each do |key|
      expect(Particle.instance_variable_get(:"@#{key}")).to eq(Particle::Default.send(key))
    end
  end

  describe ".client" do
    it "creates a Particle::Client" do
      expect(Particle.client).to be_kind_of Particle::Client
    end
    it "caches the client when the same options are passed" do
      expect(Particle.client).to eq(Particle.client)
    end
    it "returns a fresh client when options are not the same" do
      client = Particle.client
      Particle.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = Particle.client
      client_three = Particle.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    Particle::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Particle.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Particle.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

end
