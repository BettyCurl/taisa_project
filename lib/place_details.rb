module DataCollection
  # Retrieve data by place details api
  class Details
    def initialize(place_id, place_details_data)
      @details = place_details_data
      @place_id = place_id
    end

    def name
      @details['result']['name']
    end

    def rating
      @details['result']['rating']
    end

    def formatted_address
      @details['result']['formatted_address']
    end
  end
end
