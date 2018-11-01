require_relative 'google_map_api.rb'

module DataCollection
  # Retrieve data by search place API
  class Place
    attr_reader :place_id
    def initialize(place_data, data_source)
      @place_data = place_data
      @place_id = place_data['candidates'][0]['place_id']
      @data_source = data_source
    end

    def details
      @details ||= @data_source.place_details(@place_id)
    end
  end
end
