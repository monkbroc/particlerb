require 'particle/product'
require 'particle/product_firmware'

module Particle
  class Client
    # Client methods for the Particle product firmware API
    #
    # @see https://docs.particle.io/reference/api/#product-firmware
    module ProductFirmwares
      # Create a domain model for a Particle product firmware object
      #
      # @param target [String, Hash, ProductFirmware] A product id, slug, hash of attributes or {ProductFirmware} object
      # @return [ProductFirmware] A product object to interact with
      def product_firmware(product, target)
        if target.is_a? ProductFirmware
          target
        else
          ProductFirmware.new(self, product, target)
        end
      end


      # Create a domain model for a Particle product firmware object
      #
      # @param product [String, Product] A product id, slug, hash of attributes or {Product} object
      # @param params [Hash] a hash with required attributes: (:version, :title, :binary) and optional: :description
      # @return [ProductFirmware] A ProductFirmware object to interact with
      def upload_product_firmware(product, params)
        file_path = params.delete(:binary) || params.delete(:file)

        params = product_firmware_file_upload_params(file_path, params)
        res = post(product.firmware_upload_path, params)

        product.firmware(res)
      end

      def product_firmware_file_upload_params(file_path, options)
        params = {}
        params[:binary] = Faraday::UploadIO.new(file_path, "application/octet-stream")
        params[:file_type] = "binary"
        params.merge! options
        params
      end


      # Get information about a specific firmware version of a Particle Product
      #
      # @param target [ProductFirmware] A {ProductFirmware} object
      # @return [Hash] The product attributes
      def product_firmware_attributes(target)
        the_product = target.product
        get(the_product.firmware_path(target.version))
      end
    end
  end
end
