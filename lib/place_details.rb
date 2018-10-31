module DataCollection
  class PlaceDetails
    def initialize(place_id, url, place_details_data)
      @details = place_details_data
      @place_id = place_id
      @details_url = url
    end

    def url
      @details_url
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
