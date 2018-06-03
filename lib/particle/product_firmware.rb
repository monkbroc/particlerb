require 'particle/model'
require 'particle/product'

module Particle
  # Domain model for one Particle device
  class ProductFirmware < Model
    ID_REGEX = /^\d{1,6}$/

    def initialize(client, product_or_id, attributes)
      super(client, attributes)

      product = client.product(product_or_id)

      @attributes = { version: attributes } if attributes.is_a?(Integer) || attributes.is_a?(String)
      @attributes = @attributes.merge(product: product, product_id: product.id)

      @fully_loaded = true if @attributes.key?(:title)
    end

    def get_attributes
      @loaded = @fully_loaded = true
      @attributes = @client.product_firmware_attributes(self)
    end

    def version
      get_attributes unless @attributes[:version]
      @attributes[:version]
    end

    def title
      get_attributes unless @attributes[:title]
      @attributes[:title]
    end

    def description
      get_attributes unless @attributes[:description]
      @attributes[:description]
    end

    def product
      @attributes[:product]
    end

    def product_id
      product.id
    end

    def path
      "/v1/products/#{product_id}/firmware/#{version}"
    end

    def upload_path
      "/v1/products/#{product_id}/firmware"
    end
  end
end
