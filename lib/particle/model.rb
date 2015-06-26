module Particle

  # Base class for domain models
  class Model
    def initialize(client, attributes)
      @client = client
      @attributes =
        if attributes.is_a? String
          { id: attributes }
        else
          # Consider attributes loaded when passed in through constructor
          @loaded = true
          attributes
        end
    end

    # Display the attributes when inspecting the object in the console
    def inspect
      "#<#{self.class} #{@attributes}>"
    end

    # Accessor for the id
    def id
      @attributes[:id]
    end

    # Define accessor methods for attributes.
    #
    # Will load the attributes from the cloud if not already done
    def self.attribute_reader(*keys)
      keys.each do |key|
        define_method key do
          attributes[key]
        end
      end
    end

    # Hash of all attributes returned by the cloud
    def attributes
      get_attributes unless @loaded
      @attributes
    end

    # Load the model attributes with the correct API call in subclasses
    def get_attributes
      raise "Implement in subclasses and set @loaded = true"
    end
  end
end
