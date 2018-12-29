require 'particle/model'

module Particle

  # Domain model for one Particle product
  class Product < Model
    ID_REGEX = /^\d+$/

    def initialize(client, attributes)
      super(client, attributes)

      attributes = attributes.to_s if attributes.is_a?(Integer)

      if attributes.is_a? String
        if attributes =~ ID_REGEX
          @attributes = { id: attributes }
        else
          @attributes = { slug: attributes }
        end
      else
        # Listing all devices returns partial attributes so check if the
        # device was fully loaded or not
        @fully_loaded = true if attributes.key?(:name)
      end
    end

    attribute_reader :name, :description, :platform_id, :type, :hardware_version,
      :config_id, :organization

    def get_attributes
      @loaded = @fully_loaded = true
      @attributes = @client.product_attributes(self)
    end

    def devices
      @devices = @client.get_devices(id_or_slug)
    end

    # Add a Particle device to product on the account
    #
    # @example Add a device to Product
    #   product.add_device('12345')
    def add_device(device_id)
      @client.add_device(product: self, device_id: device_id)
    end

    # Remove a Particle device from a product on the account
    #
    # @example Remove a device from Product
    #   product.remove_device('12345')
    def remove_device(device_id)
      @client.remove_product_device(product: self, device_id: device_id)
    end

    def firmware(target)
      @client.product_firmware(self, target)
    end

    def upload_firmware(version, title, binary, desc = nil)
      params = { version: version, title: title, binary: binary, description: desc }
      @client.upload_product_firmware(self, params)
    end

    def id
      get_attributes unless @attributes[:id]
      @attributes[:id]
    end

    def slug
      get_attributes unless @attributes[:slug]
      @attributes[:slug]
    end

    def id_or_slug
      @attributes[:id] || @attributes[:slug]
    end

    def self.list_path
      "v1/products"
    end

    def add_device_path
      "/v1/products/#{id_or_slug}/devices"
    end

    def remove_device_path
      "/v1/products/#{id_or_slug}/devices"
    end

    def path
      "/v1/products/#{id_or_slug}"
    end

    def devices_path
      "/v1/products/#{id_or_slug}/devices"
    end

    def firmware_path(version)
      "/v1/products/#{id_or_slug}/firmware/#{version}"
    end

    def firmware_upload_path
      "/v1/products/#{id_or_slug}/firmware"
    end
  end
end
