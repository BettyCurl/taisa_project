require 'http'
require_relative 'place.rb'
require_relative 'place_details.rb'

MAP_API_BASE = 'https://maps.googleapis.com/maps/api/place/'

module DataCollection
  # Library for Google Map API
  class GoogleMapAPI
    module Errors
      class INVALID_REQUEST < StandardError; end
      class REQUEST_DENIED < StandardError; end
    end

    def initialize(key, cache: {})
      @google_map_key = key
      @cache = cache
    end

    def search_place(place_name)
      place_url = map_api_path('findplacefromtext', place_name, '')
      place_data = JSON.parse(call_map_url(place_url))
      #Place.new(place_name, place_url, place_data)
      successful?(place_data) ? Place.new(place_name, place_url, place_data) : raise_error(place_data['status'])
    end

    def place_details(place_id, details_items)
      details_url = map_api_path('details', place_id, details_items)
      details_data = JSON.parse(call_map_url(details_url))

      successful?(details_data) ? PlaceDetails.new(place_id, details_url, details_data) : raise_error(place_data['status'])
    end

    private

    def map_api_path(service, input, fields)
      case service
      when 'details'
        MAP_API_BASE + service + '/json?placeid=' + input + '&fields=' + fields
      when 'findplacefromtext'
        MAP_API_BASE + service + '/json?input=' + input + '&inputtype=textquery'
      end
    end

    def call_map_url(url)
      @cache.fetch(url) do
        HTTP.get(url + "&key=#{@google_map_key}")
      end
    end

    def successful?(result)
      result['status'] == 'OK'
    end

    def raise_error(result)
      result == 'INVALID_REQUEST' ? (raise Errors::INVALID_REQUEST) : (raise Errors::REQUEST_DENIED)
    end
  end
end
