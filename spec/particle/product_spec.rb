require 'helper'

describe Particle::Product do
  let(:product) { Particle.product(product_id) }

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
end
