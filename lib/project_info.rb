require 'http'
require 'yaml'

config = YAML.safe_load(File.read('../config/secrets.yml'))
DETAILS_ITMES = 'name,rating,formatted_address'

def map_api_path(service, input, fields)
  case service
  when 'details'
    'https://maps.googleapis.com/maps/api/place/' + service + '/json?placeid=' + input + '&fields=' + fields
  when 'findplacefromtext'
    'https://maps.googleapis.com/maps/api/place/' + service + '/json?input=' + input + '&inputtype=textquery'
  end
end

def call_map_url(config, url)
  HTTP.get(url + "&key=#{config['MAP_KEY']}")
end

map_response = {}
map_results = []

## HAPPY requests
place_url = map_api_path('findplacefromtext', 'Taipei%20Main%20Station', '')
map_response[place_url] = call_map_url(config, place_url)
place = JSON.parse(map_response[place_url])
place['url'] = place_url
map_results << place
# Should be ChIJcYy0Y3KpQjQRXiW_s2lGln8

details_url = map_api_path('details', place['candidates'][0]['place_id'], DETAILS_ITMES)
map_response[details_url] = call_map_url(config, details_url)
details = JSON.parse(map_response[details_url])
details['url'] = details_url
map_results << details

## BAD request
blank_url = map_api_path('findplacefromtext', '', '')
map_response[blank_url] = call_map_url(config, blank_url)
blank = JSON.parse(map_response[blank_url])
blank['url'] = blank_url
map_results << blank
map_response[blank_url].parse # makes sure any streaming finishes

## SAVE responses and results
File.write('../spec/fixtures/map_response.yml', map_response.to_yaml)
File.write('../spec/fixtures/map_results.yml', map_results.to_yaml)
