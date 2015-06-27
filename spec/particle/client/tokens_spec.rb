require 'helper'

describe Particle::Client::Tokens, :vcr do
  let(:username) { test_particle_username }
  let(:password) { test_particle_password }

  describe ".tokens" do
    context "with valid username and password" do
      it "returns all Particle tokens" do
        tokens = Particle.tokens(username, password)
        expect(tokens).to be_kind_of Array
        tokens.each { |t| expect(t).to be_kind_of Particle::Token }
      end
    end
    context "with invalid username" do
      it "raises BadRequest" do
        expect { Particle.tokens("invalid", "invalid") }.
          to raise_error Particle::BadRequest
      end
    end
    context "with invalid password" do
      it "raises Unauthorized" do
        expect { Particle.tokens(username, "invalid") }.
          to raise_error Particle::Unauthorized
      end
    end
  end

  describe ".create_token" do
    context "with valid username and password" do
      it "returns a new token" do
        token = Particle.create_token(username, password)
        expect(token).to be_kind_of Particle::Token
      end
    end
    context "with invalid username" do
      it "raises BadRequest" do
        expect { Particle.create_token("invalid", "invalid") }.
          to raise_error Particle::BadRequest
      end
    end
    context "with invalid password" do
      it "raises BadRequest" do
        expect { Particle.create_token(username, "invalid") }.
          to raise_error Particle::BadRequest
      end
    end
  end

  describe ".login" do
    it "returns a new token" do
      token = Particle.login(username, password)
      expect(token).to be_kind_of Particle::Token
    end

    it "sets the new token on the client" do
      #puts Particle.client.inspect
      token = Particle.login(username, password)
      puts Particle.client.inspect
      expect(Particle.client.access_token).to eq token.access_token
    end
  end

  describe ".remove_token", :vcr do
    context "when the webhook exists" do
      it "removes the token" do
        token = Particle.create_token(username, password)
        expect(Particle.remove_token(username, password, token)).to eq true
      end
    end

    context "when the token doesn't exist" do
      # FIXME: API bug: return 200 OK when deleting a wrong token
      # it "raises Forbidden" do
      #   expect { Particle.remove_token(username, password, "1" * 24) }.
      #     to raise_error(Particle::Forbidden)
      # end
    end
  end
end
