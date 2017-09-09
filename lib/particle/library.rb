require 'particle/model'

module Particle

  # Domain model for a firmware library
  class Library < Model
    def initialize(client, attributes)
      super(client, attributes)
      if attributes.is_a? String
        @attributes = { name: attributes }
      end
    end

  end
end
