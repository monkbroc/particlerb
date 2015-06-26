module Particle
  class Client

    # Client methods for the Particle publish API
    #
    # @see http://docs.particle.io/core/api/#publishing-events
    module Publish

      # Publish an event to your devices
      #
      # @param options [Hash]
      #     * :name [String]: name of the event to publish
      #     * :data [String,Hash]: optional data to include with the event
      #     * :ttl [Number]: optional Time-To-Live in seconds for the
      #       event (currently ignored by the cloud)
      #     * :private [boolean]: optional key to indicate event should
      #       be published only to your own devices
      # @return [boolean] true for success
      def publish(options)
        params = {
          name: options.fetch(:name)
        }
        case options[:data]
        when Hash, Array then params[:data] = options[:data].to_json
        else params[:data] = options[:data].to_s
        end

        params[:ttl] = options[:ttl] if options[:ttl]
        params[:private] = true if options[:private]

        result = post(Event.publish_path, params)
        result.ok
      end
    end
  end
end
