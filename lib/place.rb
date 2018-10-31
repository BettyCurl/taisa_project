require_relative 'google_map_api.rb'

module DataCollection
  class Place
    def initialize(place_name, url, data_source)
      @place_name = place_name
      @place_url = url
      @place_id = data_source['candidates'][0]['place_id']
      @data_source = data_source
    end

    def place_id
      @place_id
    end

    def url
      @place_url
    end

    def search_text
      @place_name
    end
  end
end
