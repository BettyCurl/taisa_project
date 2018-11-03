module ServiceMap
  module Entity
    # Domain entity for service points
    class ServicePointDetails < Dry::Struct
      include Dry::Types.module

      attribute :id,                Integer.optional
      attribute :origin_id,         Strict::String
      attribute :name,              Strict::String
      attribute :rating,            Strict::Float
      attribute :formatted_address, Strict::String
    end
  end
end
