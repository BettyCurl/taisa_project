require_relative 'details_mapper.rb'

module ServiceMap
  module GoogleMap
    # Data Mapper: Google Map place -> service point entity
    class PointMapper
      def initialize(gm_key, gateway_class = GoogleMap::Api)
        @key = gm_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def find(place_name)
        data = @gateway.search_place(place_name)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @key, @gateway_class).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        attr_reader :place_id
        def initialize(data, key, gateway_class)
          @data = data
          @place_id = data['candidates'][0]['place_id']

          @details_mapper = DetailsMapper.new(
            key, @place_id, gateway_class
          )
        end

        def build_entity
          ServiceMap::Entity::ServicePoint.new(
            id: nil,
            origin_id: @place_id,
            details: details
          )
        end

        def details
          @details ||= @details_mapper.load_details
        end
      end
    end
  end
end
