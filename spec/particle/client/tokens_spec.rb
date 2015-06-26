require 'helper'

describe Particle::Client::Tokens do
  let(:username) { test_particle_username }
  let(:password) { test_particle_password }

  describe ".tokens", :vcr do
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

  describe ".create_token", :vcr do
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


  # describe ".webhook_attributes", :vcr do
  #   context "when the webhook exists" do
  #     it "returns attributes" do
  #       attr = Particle.webhook_attributes(id)
  #       expect(attr[:webhook]).to include(:id, :url)
  #     end
  #   end
  #   context "when webhook doesn't exist" do
  #     it "raises Forbidden" do
  #       expect { Particle.webhook_attributes("1" * 24) }.
  #         to raise_error(Particle::Forbidden)
  #     end
  #   end
  # end

  # def create_webhook(options = {})
  #   params = {
  #     url: "https://example.com",
  #     event: "68c57e6752d5e0a5" # bogus event name that should never match
  #   }.merge(options)
  #   Particle.create_webhook(params)
  # end


  # describe ".create_webhook", :vcr do
  #   it "creates a webhook with minimum parameters" do
  #     webhook = create_webhook
  #     expect(webhook).to be_kind_of Particle::Webhook
  #   end

  #   context "when there are too many hooks" do
  #     # FIXME: currently returns 200 OK
  #     # it "raises BadRequest" do
  #     #   # Make sure to have 10 webhooks before recording this
  #     #   # VCR cassette
  #     #   expect { create_webhook }.
  #     #     to raise_error Particle::BadRequest
  #     # end
  #   end
  # end

  # describe ".remove_webhook", :vcr do
  #   context "when the webhook exists" do
  #     it "removes the webhook" do
  #       webhook = create_webhook
  #       expect(Particle.remove_webhook(webhook)).to eq true
  #     end
  #   end

  #   context "when the webhook doesn't exist" do
  #     it "raises Forbidden" do
  #       expect { Particle.remove_webhook("1" * 24) }.
  #         to raise_error(Particle::Forbidden)
  #     end
  #   end
  # end
end
