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

        # originally returned as an array, now seems to just return the 1 product as a hash;
        # this will handle both cases
        product = response_body[:product]
        product = product.first if product.is_a?(Array)
        product
      end
    end
  end
end
