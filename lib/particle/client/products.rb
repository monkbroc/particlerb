require 'particle/product'

module Particle
  class Client
    # Client methods for the Particle product API
    #
    # @see https://docs.particle.io/reference/api/#products
    module Products
      # Create a domain model for a Particle product
      #
      # @param target [String, Hash, Product] A product id, slug, hash of attributes or {Product} object
      # @return [Product] A product object to interact with
      def product(target)
        if target.is_a? Product
          target
        else
          Product.new(self, target)
        end
      end

      # List all Particle products on the account
      #
      # @return [Array<Product>] List of Particle products to interact with
      def products
        response_body = get(Product.list_path)
        (response_body[:products]).map { |attributes| product(attributes) }
      end

      # Get information about a Particle product
      #
      # @param target [String, Product] A product id, slug or {Product} object
      # @return [Hash] The product attributes
      def product_attributes(target)
        response_body = get(product(target).path)

        response_body[:product].first
      end

      # List all Particle product devices on the account
      #
      # @return [Array<Device>] List of Particle product devices to interact with
      def get_devices(target)
        response_body = get(product(target).devices_path)
        (response_body[:devices]).map { |attributes| device(attributes) }
      end

      # Add device to Particle product on the account
      #
      # @param product [Product] A product to interact with
      # @param device_id [String] A device id
      # @return [Hash] JSON response as a hash
      def add_device(product:, device_id:)
        post(product.add_device_path, id: device_id)
      end
    end
  end
end