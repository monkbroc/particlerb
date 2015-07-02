require 'helper'

describe Particle::Webhook do
  describe "Particle.webhook" do
    it "creates a Webhook" do
      expect(Particle.webhook("abc").id).to eq("abc")
    end
  end

  def create_webhook(options = {})
    params = {
      url: "https://example.com",
      event: "68c57e6752d5e0a5" # bogus event name that should never match
    }.merge(options)
    Particle.webhook(params).create
  end

  describe ".attributes", :vcr do
    let(:webhook) { Particle.webhook(create_webhook.id) }
    after do
      webhook.remove
    end

    it "returns attributes" do
      expect(webhook.attributes).to be_kind_of Hash
    end
    it "includes details like url" do
      expect(webhook.attributes[:url]).to be_kind_of String
    end
  end

  describe ".create", :vcr do
    it "creates the webhook" do
      webhook = create_webhook
      expect(webhook).to be_kind_of Particle::Webhook
      webhook.remove
    end
  end

  describe ".remove", :vcr do
    it "removes the webhook" do
      webhook = create_webhook
      expect(webhook.remove).to eq true
    end
  end
end
