require 'helper'

describe Particle::ProductFirmware do
  let(:product) { Particle.product(product_id) }
  let(:product_firmware) { Particle.product_firmware(product, product_firmware_version) }

  describe "Particle.product_firmware" do
    it "creates a product firmware object" do
      expect(product_firmware.version).to eq(product_firmware_version)
    end
  end

  describe ".attributes", :vcr do
    it "returns attributes" do
      expect(product_firmware.attributes).to be_kind_of Hash
      expect(product_firmware.title).to be_kind_of String
    end
  end

  describe ".upload_firmware", :vcr do
    let(:new_version) { 3 }
    let(:title) { 'Test Firmware Upload' }
    let(:description) { 'upload description' }

    let(:binary) { test_product_firmware_binary }

    it "uploads and returns a firmware object" do
      product_firmware = product.upload_firmware(new_version, title, binary, description)

      expect(product_firmware.version).to eq(new_version)
      expect(product_firmware.title).to eq(title)
      expect(product_firmware.description).to eq(description)
    end
  end
end
