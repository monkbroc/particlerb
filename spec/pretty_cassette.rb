require 'multi_json'

module VCR
  class Cassette
    class Serializers
      module PrettyJSON
        extend VCR::Cassette::Serializers::JSON
        extend EncodingErrorHandling
        extend self

        # Serializes the given hash using `MultiJson`.
        #
        # @param [Hash] hash the object to serialize
        # @return [String] the JSON string
        def serialize(hash)
          handle_encoding_errors do
            MultiJson.dump(hash, pretty: true)
          end
        end
      end
    end
  end
end
