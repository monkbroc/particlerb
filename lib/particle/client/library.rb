require 'particle/library'

module Particle
  class Client

    # Client methods for the Particle firmware library API
    # 
    # @see https://docs.particle.io/reference/api/#libraries
    module Libraries

      # Create a domain model for a firmware library
      #
      # @param target [String, Hash, Library] A library name, hash of attributes or {Library} object
      # @return [Library] A library object to interact with
      def library(target)
        if target.is_a? Library
          target
        else
          Library.new(self, target)
        end
      end

      # List firmware libraries, sorted, filtered and paginated
      # 
        
    end
  end
end
