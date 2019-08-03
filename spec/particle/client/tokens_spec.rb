require 'helper'

describe Particle::Client::Tokens, :vcr do
  let(:username) { test_particle_username }
  let(:password) { test_particle_password }
  let(:client) { test_particle_oauth_client }
  let(:secret) { test_particle_oauth_secret }

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
    context "default client" do
      context "with valid username and password" do
        it "returns a new token" do
          token = Particle.create_token(username, password)
          expect(token).to be_kind_of Particle::Token
          Particle.remove_token(username, password, token)
        end
        it "creates a token with a specific expiration duration" do
          token = Particle.create_token(username, password, expires_in: 3600)
          expect(token.attributes[:expires_in]).to eq 3600
          Particle.remove_token(username, password, token)
        end
        it "creates a token with a specific expiration date" do
          date = Date.today + 90
          day_in_seconds = 24 * 60 * 60
          token = Particle.create_token(username, password, expires_at: date)
          expect(token.attributes[:expires_in]).
            to be_within(2 * day_in_seconds).of(90 * day_in_seconds)
          Particle.remove_token(username, password, token)
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
    context "with an oauth client" do
      context "with valid username and password" do
        it "returns a new token" do
          token = Particle.create_token(username, password, {
            client: client,
            secret: secret,
            grant_type: 'password'
          })
          expect(token).to be_kind_of Particle::Token
          Particle.remove_token(username, password, token)
        end
      end
      context "with invalid username" do
        it "raises BadRequest" do
          expect { Particle.create_token("invalid", "invalid", {
            client: client,
            secret: secret,
            grant_type: 'password'
          }) }.to raise_error Particle::BadRequest
        end
      end
      context "with invalid password" do
        it "raises BadRequest" do
          expect { Particle.create_token(username, "invalid", {
            client: client,
            secret: secret,
            grant_type: 'password'
          }) }.to raise_error Particle::BadRequest
        end
      end
    end
    context "with an invalid oauth secret" do
      # Bug: It just ends up using the default OAuth particle:particle client
      # so the request doesn't fail
      # it "raises BadRequest" do
      #   expect { Particle.create_token(username, password, {
      #     client: client,
      #     secret: 'invalid',
      #     grant_type: 'password'
      #   }) }.to raise_error Particle::BadRequest
      # end
    end
  end

  describe ".login" do
    it "returns a new token" do
      token = Particle.login(username, password)
      expect(token).to be_kind_of Particle::Token
      Particle.remove_token(username, password, token)
    end

    it "sets the new token on the module" do
      token = Particle.login(username, password)
      expect(Particle.access_token).to eq token.access_token
      Particle.remove_token(username, password, token)
    end

    it "sets the new token on the client" do
      client = Particle::Client.new
      token = client.login(username, password)
      expect(client.access_token).to eq token.access_token
      client.remove_token(username, password, token)
    end
  end

  describe ".remove_token", :vcr do
    context "when the token exists" do
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

  describe "when using an expired token", :vcr do
    it "raises Unauthorized" do
      token = Particle.login(username, password, expires_in: 5)

      # Let token expire
      sleep(10) if VCR.current_cassette.recording?

      expect { Particle.devices }.
        to raise_error(Particle::Unauthorized)

      Particle.remove_token(username, password, token)
    end
  end
end
