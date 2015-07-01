require 'particle/device'
require 'ostruct'

module Particle
  class Client

    # Client methods for the Particle firmware flash API
    #
    # @see http://docs.particle.io/core/api/#basic-functions-verifying-and-flashing-new-firmware
    module Firmware
      COMPILE_PATH = "v1/binaries"
      PLATFORMS = {
        core: 0,
        photon: 6,
        p1: 8
      }

      # Flash new firmware to a Particle device from source code or
      # binary
      #
      # @param target [String, Device] A device id, name or {Device} object that will
      #                                receive the new firmware
      # @param file_paths [Array<String>] File paths to send to cloud
      #                                   and flash
      # @param options [Hash] Flashing options
      #                       :binary => true to skip the compile stage
      # @return [OpenStruct] Result of flashing.
      #                :ok => true on success
      #                :errors => String with compile errors
      #                
      def flash_device(target, file_paths, options = {})
        params = file_upload_params(file_paths, options)
        result = put(device(target).path, params)
        # Normalize the weird output structure
        if result[:ok] == false
          errors = result[:errors][0]
          result[:errors] = if errors.is_a? Hash
                              errors[:errors][0]
                            else
                              result
                            end
        elsif result[:status] == "Update started"
          result[:ok] = true
        end
        OpenStruct.new(result)
      end

      # Compile firmware from source code for a specific Particle device
      #
      # @param file_paths [Array<String>] File paths to send to cloud
      #                                   and flash
      # @param options [Hash] Compilation options
      #                       :device_id => Compile for a specific device
      #                       :platform => Compile for a specific platform (:core or :photon)
      #                       :platform_id => Compile for a specific platform id
      #                       :product_id => Compile for a specific product
      # @return [OpenStruct] Result of flashing.
      #                :ok => true on success
      #                :errors => String with compile errors
      #                
      def compile_code(file_paths, options = {})
        normalize_platform_id(options)
        params = file_upload_params(file_paths, options)
        result = post(COMPILE_PATH, params)
        # Normalize the weird output structure
        if result[:ok] == false
          result[:errors] = result[:errors][0]
        end
        OpenStruct.new(result)
      end

      # Download compiled binary firmware
      #
      # @param binary_id [String] Id of the compiled binary to download
      # @return [String] Binary bytes
      #                
      def download_binary(binary_id)
        get(binary_path(binary_id))
      end

      private

      def binary_path(id)
        COMPILE_PATH + "/#{id}"
      end

      def file_upload_params(file_paths, options)
        params = {}
        mime_type = options[:binary] ? "application/octet-stream" : "text/plain"

        file_paths = [file_paths] unless file_paths.is_a? Array
        file_paths.each_with_index do |file, index|
          params[:"file#{index > 0 ? index : ""}"] =
            Faraday::UploadIO.new(file, mime_type)
        end
        params[:file_type] = "binary" if options.delete(:binary)
        params.merge! options
        params
      end

      def normalize_platform_id(options)
        if options[:platform]
          options[:platform_id] = PLATFORMS[options.delete(:platform)]
        end
      end
    end
  end
end
