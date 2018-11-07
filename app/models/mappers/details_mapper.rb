module ServiceMap
  module GoogleMap
    # Data Mapper: Google Map Details -> Details entity
    class DetailsMapper
      def initialize(gm_key, place_id, gateway_class = GoogleMap::Api)
        @key = gm_key
        @place_id = place_id
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key)
      end

      def load_details
        data = @gateway.place_details(@place_id, 'name,rating,formatted_address')
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @place_id).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, origin_id)
          @data = data
          @id = origin_id
        end

        def build_entity
          Entity::ServicePointDetails.new(
            id: nil,
            origin_id: @id,
            name: name,
            rating: rating,
            formatted_address: formatted_address
          )
        end

        private

        def name
          @data['result']['name']
        end

        def rating
          @data['result']['rating']
        end

        def formatted_address
          @data['result']['formatted_address']
        end
      end
    end
  end
end
