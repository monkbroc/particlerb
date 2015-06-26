require 'helper'

describe Particle::Client::Webhooks do
  let(:id) { test_particle_webhook_ids[0] }

  describe ".webhooks", :vcr do
    it "returns all Particle webhooks" do
      webhooks = Particle.webhooks
      expect(webhooks).to be_kind_of Array
    end
  end

  describe ".webhook_attributes", :vcr do
    context "when the webhook exists" do
      it "returns attributes" do
        attr = Particle.webhook_attributes(id)
        expect(attr[:webhook]).to include(:id, :url)
      end
    end
    context "when webhook doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.webhook_attributes("1" * 24) }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  def create_webhook(options = {})
    params = {
      url: "https://example.com",
      event: "68c57e6752d5e0a5" # bogus event name that should never match
    }.merge(options)
    Particle.create_webhook(params)
  end


  describe ".create_webhook", :vcr do
    it "creates a webhook with minimum parameters" do
      webhook = create_webhook
      expect(webhook).to be_kind_of Particle::Webhook
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

  describe ".remove_webhook", :vcr do
    context "when the webhook exists" do
      it "removes the webhook" do
        webhook = create_webhook
        expect(Particle.remove_webhook(webhook)).to eq true
      end
    end

    context "when the webhook doesn't exist" do
      it "raises Forbidden" do
        expect { Particle.remove_webhook("1" * 24) }.
          to raise_error(Particle::Forbidden)
      end
    end
  end

  #describe ".rename_device", :vcr do
  #  context "when the device exists" do
  #    it "renames the device" do
  #      expect(Particle.rename_device(id, "fiesta")).to eq true
  #    end
  #  end

  #  context "when the device doesn't exist" do
  #    it "raises Forbidden" do
  #      expect { Particle.rename_device("1234", "blah") }.
  #        to raise_error(Particle::Forbidden)
  #    end
  #  end
  #end

  #describe ".call_function", :vcr do
  #  context "when the device is online" do
  #    context "when the function exists" do
  #      it "calls the function on the device firmware" do
  #        # Test device must have a method called "get" returning -2
  #        expect(Particle.call_function(id, "get")).to eq -2
  #      end
  #    end

  #    context "when the function doesn't exist" do
  #      it "raises NotFound" do
  #        expect { Particle.call_function(id, "blahblah") }.
  #          to raise_error(Particle::NotFound)
  #      end
  #    end
  #  end

  #  context "when the device is offline" do
  #    # FIXME: API Bug? I expected TimedOut here
  #    it "raises BadRequest" do
  #      # Test device must be offline before recording VCR cassette
  #      expect { Particle.call_function(id, "get") }.
  #        to raise_error(Particle::BadRequest)
  #    end
  #  end

  #  context "when the device doesn't exist" do
  #    it "raises Forbidden" do
  #      expect { Particle.call_function("1234", "get") }.
  #        to raise_error(Particle::Forbidden)
  #    end
  #  end
  #end

  #describe ".get_variable", :vcr do
  #  context "when the device is online" do
  #    context "when the variable exists" do
  #      it "returns the value on the firmware variable" do
  #        # Test device must have a variable called "result" returning a String
  #        expect(Particle.get_variable(id, "result")).to eq "3600"
  #      end
  #    end

  #    context "when the variable doesn't exist" do
  #      it "raises NotFound" do
  #        expect { Particle.get_variable(id, "blahblah") }.
  #          to raise_error(Particle::NotFound)
  #      end
  #    end
  #  end

  #  context "when the device is offline" do
  #    it "raises TimedOut" do
  #      # Test device must be offline before recording VCR cassette
  #      expect { Particle.get_variable(id, "result") }.
  #        to raise_error(Particle::TimedOut)
  #    end
  #  end

  #  context "when the device doesn't exist" do
  #    it "raises Forbidden" do
  #      expect { Particle.get_variable("1234", "result") }.
  #        to raise_error(Particle::Forbidden)
  #    end
  #  end
  #end

  #describe ".signal_device", :vcr do
  #  context "when the device is online" do
  #    it "starts shouting rainbows" do
  #      expect(Particle.signal_device(id, true)).to eq true
  #    end
  #    it "stops shouting rainbows" do
  #      expect(Particle.signal_device(id, false)).to eq false
  #    end
  #  end

  #  context "when the device is offline" do
  #    # FIXME: API bug. Should return HTTP 408 to raise TimedOut
  #    it "raises TimedOut" do
  #      # Test device must be offline before recording VCR cassette
  #      # expect { Particle.signal_device(id, true) }.to raise_error(Particle::TimedOut)
  #      expect(Particle.signal_device(id, true)).to eq false
  #    end
  #  end

  #  context "when the device doesn't exist" do
  #    it "raises Forbidden" do
  #      expect { Particle.signal_device("1234", true) }.
  #        to raise_error(Particle::Forbidden)
  #    end
  #  end
  #end
end
