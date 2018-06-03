require 'helper'

describe Particle::Client::Products, :vcr do
  describe '.products' do
    it 'returns all Particle products' do
      products = Particle.products
      expect(products).to be_kind_of Array
      products.each { |prod| expect(prod).to be_kind_of Particle::Product }
    end
  end

  describe '.product_attributes' do
    it 'returns attributes' do
      attr = Particle.product_attributes(product_id)

      expect(attr.keys).to include(
        :id, :name, :description, :platform_id, :type, :hardware_version,
        :config_id, :organization
      )

      expect(attr[:id]).to eq product_id.to_i
    end

    context "when product doesn't exist" do
      it 'raises NotFound' do
        expect { Particle.product_attributes('123456') }.
          to raise_error(Particle::NotFound)
      end
    end
  end
end
