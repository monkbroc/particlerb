require 'particle/device'

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
      # @return [Device] A device object to interact with
      def flash(target, file_paths)
        params = {}
        file_paths.each_with_index do |file, index|
          params[:"file#{index > 0 ? index : ""}"] =
            Faraday::UploadIO.new(file, "text/plain")
        end
        puts device(target).path
        result = request(:put, device(target).path, params)
        result.ok
      end

      # # Remove a Particle device from your account
      # #
      # # @param target [String, Device] A device id, name or {Device} object
      # # @return [boolean] true for success
      # def remove_device(target)
      #   result = delete(device(target).path)
      #   result.ok
      # end

      # # Rename a Particle device in your account
      # #
      # # @param target [String, Device] A device id, name or {Device} object
      # # @param name [String] New name for the device
      # # @return [boolean] true for success
      # def rename_device(target, name)
      #   result = put(device(target).path, name: name)
      #   result.name == name
      # end

      # # Call a function in the firmware of a Particle device
      # #
      # # @param target [String, Device] A device id, name or {Device} object
      # # @param name [String] Function to run on firmware
      # # @param argument [String] Argument string to pass to the firmware function
      # # @return [Integer] Return value from the firmware function
      # def call_function(target, name, argument = "")
      #   result = post(device(target).function_path(name), arg: argument)
      #   result.return_value
      # end

      # # Get the value of a variable in the firmware of a Particle device
      # #
      # # @param target [String, Device] A device id, name or {Device} object
      # # @param name [String] Variable on firmware
      # # @return [String, Number] Value from the firmware variable
      # def get_variable(target, name)
      #   result = get(device(target).variable_path(name))
      #   result.result
      # end

      # # Signal the device to start blinking the RGB LED in a rainbow
      # # pattern. Useful to identify a particular device.
      # #
      # # @param target [String, Device] A device id, name or {Device} object
      # # @param enabled [String] Whether to enable or disable the rainbow signal
      # # @return [boolean] true when signaling, false when stopped
      # def signal_device(target, enabled = true)
      #   result = put(device(target).path, signal: enabled ? '1' : '0')
      #   # FIXME: API bug. Should return HTTP 408 so result.ok wouldn't be necessary
      #   if result.ok == false
      #     false
      #   else
      #     result.signaling
      #   end
      # end
    end
  end
end
