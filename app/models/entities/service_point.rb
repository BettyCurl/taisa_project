module ServiceMap
  module Entity
    # Domain entity for service points
    class ServicePoint < Dry::Struct
      include Dry::Types.module

      attribute :id,                Integer.optional
      attribute :origin_id,         Strict::String # Place_id
      attribute :details,           ServicePointDetails
    end
  end
end
