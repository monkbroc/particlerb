require 'helper'

describe Particle::Webhook do
  let(:id) { test_particle_webhook_ids[0] }
  let(:webhook) { Particle.webhook(id) }

  describe "Particle.webhook" do
    it "creates a Webhook" do
      expect(Particle.webhook("abc").id).to eq("abc")
    end
  end

  describe ".attributes", :vcr do
    it "returns attributes" do
      expect(webhook.attributes).to be_kind_of Hash
    end
  end

  def create_webhook(options = {})
    params = {
      url: "https://example.com",
      event: "68c57e6752d5e0a5" # bogus event name that should never match
    }.merge(options)
    Particle.webhook(params).create
  end

  describe ".create", :vcr do
    it "creates the webhook" do
      expect(create_webhook).to be_kind_of Particle::Webhook
    end
  end

  describe ".remove", :vcr do
    it "removes the webhook" do
      webhook = create_webhook
      expect(webhook.remove).to eq true
    end
  end

  #describe ".rename", :vcr do
  #  it "renames the device" do
  #    expect(device.rename("fiesta")).to eq true
  #  end
  #end

  #describe ".function", :vcr do
  #  it "call the function on the device firmware" do
  #    # Test device must have a method called "get" returning -2
  #    expect(device.function("get")).to eq -2
  #  end
  #end

  #describe ".variable", :vcr do
  #  it "gets the value of the firmware variable" do
  #    # Test device must have a variable called "result" returning a String
  #    expect(device.variable("result")).to eq "3600"
  #  end
  #end

  #describe ".signal", :vcr do
  #  it "starts shouting rainbows" do
  #    expect(device.signal).to eq true
  #  end
  #end
end

