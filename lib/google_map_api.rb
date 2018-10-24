require 'http'
require_relative 'place.rb'
require_relative 'place_details.rb'

module DataCollection
  # Library for Google Map API
  class GoogleMapAPI
    module Errors
      class INVALID_REQUEST < StandardError; end
      class REQUEST_DENIED < StandardError; end
    end

     #STATUS_ERROR = {
     #  0 => Errors::REQUEST_DENIED,
     #  1 => Errors::INVALID_REQUEST
     #}.freeze
  
    def initialize(key, cache: {})
      @google_map_key = key
      @cache = cache
    end

    def search_place(place_name)
      place_url = map_api_path( 'findplacefromtext' , place_name , '')
      # place_name equals 'Taipei%20Main%20Station'. How to ensure the char at place_name?
      place_data = JSON.parse(call_map_url(place_url))
      place_data['status'] == "OK" ? Place.new(place_name, place_url, place_data) : raise_error(place_data['status'])
    end

    def place_details(place_id)
      details_url = map_api_path( 'details' , place_id , 'name,rating,formatted_address')
      details_data = JSON.parse(call_map_url(details_url))
      PlaceDetails.new(place_id, details_url, details_data)
    end

    private

    def map_api_path(service, input, fields)
      return 'https://maps.googleapis.com/maps/api/place/' + service + '/json?placeid=' + input + '&fields=' + fields if service == 'details'
      return 'https://maps.googleapis.com/maps/api/place/' + service + '/json?input=' + input + '&inputtype=textquery' if service == 'findplacefromtext'
    end

    def call_map_url(url)
      result = @cache.fetch(url) do 
        HTTP.get(url + "&key=#{@google_map_key}")
      end
      #result_data = successful?(result) ? result : raise_error(result)
    end

    #def successful?(result)
    #  HTTP_ERROR.keys.include?(result.code)? false : true
    #end

    #def raise_error(result)
    #  raise (STATUS_ERROR[result])
    #end

  end

end