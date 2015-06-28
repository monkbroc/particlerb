require 'particle/device'
require 'ostruct'

module Particle
  class Client

    # Client methods for the Particle firmware flash API
    #
    # @see http://docs.particle.io/core/api/#basic-functions-verifying-and-flashing-new-firmware
    module Firmware

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
        params = file_upload_params(file_paths, options[:binary])
        result = request(:put, device(target).path, params)
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

      private

      def file_upload_params(file_paths, binary)
        params = {}
        mime_type = binary ? "application/octet-stream" : "text/plain"

        file_paths = [file_paths] unless file_paths.is_a? Array
        file_paths.each_with_index do |file, index|
          params[:"file#{index > 0 ? index : ""}"] =
            Faraday::UploadIO.new(file, mime_type)
        end
        params[:file_type] = "binary" if binary
        params
      end

    end
  end
end
