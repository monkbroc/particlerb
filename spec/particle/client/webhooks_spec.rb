require 'helper'

describe Particle::Client::Webhooks, :vcr do
  def create_webhook(options = {})
    params = {
      url: "https://example.com",
      event: "68c57e6752d5e0a5" # bogus event name that should never match
    }.merge(options)
    Particle.create_webhook(params)
  end

  describe ".webhooks" do
    it "returns all Particle webhooks" do
      id = create_webhook.id

      webhooks = Particle.webhooks
      expect(webhooks).to be_kind_of Array
      webhooks.each { |w| expect(w).to be_kind_of Particle::Webhook }

      Particle.remove_webhook(id)
    end
  end

  describe ".webhook_attributes" do
    context "when the webhook exists" do
      it "returns attributes" do
        id = create_webhook.id
        attr = Particle.webhook_attributes(id)
        expect(attr[:webhook]).to include(:id, :url)
        Particle.remove_webhook(id)
      end
    end
    context "when webhook doesn't exist" do
      it "raises NotFound" do
        expect { Particle.webhook_attributes("1" * 24) }.
          to raise_error(Particle::NotFound)
      end
    end
  end

  describe ".create_webhook" do
    it "creates a webhook with minimum parameters" do
      webhook = create_webhook
      expect(webhook).to be_kind_of Particle::Webhook
      Particle.remove_webhook(webhook)
    end

    context "when there are too many hooks" do
      # FIXME: currently returns 200 OK
      # it "raises BadRequest" do
      #   # Make sure to have 10 webhooks before recording this
      #   # VCR cassette
      #   expect { create_webhook }.
      #     to raise_error Particle::BadRequest
      # end
    end
  end

  describe ".remove_webhook" do
    context "when the webhook exists" do
      it "removes the webhook" do
        webhook = create_webhook
        expect(Particle.remove_webhook(webhook)).to eq true
      end
    end

    context "when the webhook doesn't exist" do
      it "raises NotFound" do
        expect { Particle.remove_webhook("1" * 24) }.
          to raise_error(Particle::NotFound)
      end
    end
  end
end
