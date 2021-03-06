require 'http'

module ServiceMap
  module GoogleMap
    # Library for Google Map API
    class Api
      def initialize(key, cache: {})
        @key = key
        @cache = cache
      end

      def search_place(place_name)
        Request.new(@key).get_response('findplacefromtext', place_name, '')
      end

      def place_details(place_id, detail_items)
        Request.new(@key).get_response('details', place_id, detail_items)
      end

      # Sends out HTTP requests to Github
      class Request
        MAP_API_BASE = 'https://maps.googleapis.com/maps/api/place/'.freeze

        def initialize(key, cache = {})
          @key = key
          @cache = cache
        end

        def get_response(service, input, fields)
          case service
          when 'details'
            get(MAP_API_BASE + service + '/json?placeid=' + input + '&fields=' + fields)
          when 'findplacefromtext'
            get(MAP_API_BASE + service + '/json?input=' + input + '&inputtype=textquery')
          end
        end

        def get(url)
          http_response = @cache.fetch(url) do
            HTTP.get(url + "&key=#{@key}")
          end

          Response.new(http_response.parse).tap do |response|
            response.raise_error(response) unless response.successful?(response)
          end
        end
      end
      # Decorates HTTP responses from Google MAP with success/error
      class Response < SimpleDelegator
        # Request item is not available.
        InvalidRequest = Class.new(StandardError)
        # key is not correct
        class RequestDenied < StandardError; end

        def successful?(result)
          result['status'] == 'OK'
        end

        def raise_error(result)
          raise InvalidRequest if result['status'] == 'INVALID_REQUEST'
          raise RequestDenied unless result['status'] == 'INVALID_REQUEST'
        end
      end
    end
  end
end
