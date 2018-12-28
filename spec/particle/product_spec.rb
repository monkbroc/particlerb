require 'helper'

describe Particle::Product do
  let(:product) { Particle.product(product_id) }
  let(:product_devices) { Particle.product(product_id).devices }
  let(:add_product_device) { product.add_device(device_id: '12345') }

  describe "Particle.product" do
    it "creates a product" do
      expect(Particle.product("abc").slug).to eq("abc")
    end
  end

  describe ".attributes", :vcr do
    it "returns attributes" do
      expect(product.name).to be_kind_of String
      expect(product.attributes).to be_kind_of Hash
    end
  end

  describe ".devices", :vcr do
    it "returns devices" do
      expect(product_devices).to be_kind_of Array
      expect(product_devices.last.id).to be_kind_of String
    end
  end

  describe ".add_device", :vcr do
    it "returns response" do
      expect(add_product_device).to be_kind_of Hash
      expect(add_product_device[:updated]).to eq(1)
    end
  end
end