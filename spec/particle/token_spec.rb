require 'helper'

describe Particle::Token do
  let(:username) { test_particle_username }
  let(:password) { test_particle_password }

  describe "Particle.token" do
    it "creates a Token" do
      expect(Particle.token("abc").access_token).to eq("abc")
    end
  end

  describe ".attributes", :vcr do
    it "returns attributes" do
      token = Particle.tokens(username, password).first
      expect(token.attributes).to be_kind_of Hash
    end
  end

  describe ".create", :vcr do
    it "creates a token" do
      token = Particle.token.create(username, password)
      expect(token).to be_kind_of Particle::Token
      token.remove(username, password)
    end
  end

  describe ".remove", :vcr do
    it "removes the token" do
      token = Particle.create_token(username, password)
      expect(token.remove(username, password)).to eq true
    end
  end
end
