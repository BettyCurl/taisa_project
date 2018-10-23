require 'http'
require 'yaml'

config = YAML.safe_load(File.read('../config/secrets.yml'))

# "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Taipei%20Main%20Station&inputtype=textquery&key=AIzaSyD44w7DcwWEjSPw-wN1OwsPvuh0VWg4UBU"
# "https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4&fields=name,rating,formatted_address&key=AIzaSyD44w7DcwWEjSPw-wN1OwsPvuh0VWg4UBU"
def map_api_path(service, input, fields)
  return 'https://maps.googleapis.com/maps/api/place/' + service + '/json?placeid=' + input + '&fields=' + fields if service == 'details'
  return 'https://maps.googleapis.com/maps/api/place/' + service + '/json?input=' + input + '&inputtype=textquery' if service == 'findplacefromtext'
end

def call_map_url(config, url)
  HTTP.get(url + "&key=#{config['MAP_KEY']}")
end

map_response = {}
map_results = {}

## HAPPY requests
place_url = map_api_path( 'findplacefromtext' , 'Taipei%20Main%20Station', '')
map_response[place_url.to_sym] = call_map_url(config, place_url)
place = JSON.parse(map_response[place_url.to_sym], :symbolize_names => true)
map_results[:place_id] = place[:candidates][0][:place_id]
## Why not place[:candidates][:place_id]??
# Should be ChIJcYy0Y3KpQjQRXiW_s2lGln8

#details_url = map_api_path('details', 'ChIJcYy0Y3KpQjQRXiW_s2lGln8','name,rating,formatted_address')


details_url = map_api_path('details', map_results[:place_id],'name,rating,formatted_address')
map_response[details_url.to_sym] = call_map_url(config, details_url)
details = JSON.parse(map_response[details_url.to_sym], :symbolize_names => true)
map_results[:formatted_address] = details[:result][:formatted_address]
# should be Taiwan, \u53F0\u5317\u5E02\u9ECE\u660E\u91CC

map_results[:name] = details[:result][:name]
# should be Taipei Main Station

map_results[:rating] = details[:result][:rating]
# should be 4.1

## BAD request
bad_project_url = map_api_path('findplacefromtext', '', '')
map_response[bad_project_url] = call_map_url(config, bad_project_url)
map_response[bad_project_url].parse # makes sure any streaming finishes

## SAVE responses and results
File.write('../spec/fixtures/map_response.yml', map_response.to_yaml)
File.write('../spec/fixtures/map_results.yml', map_results.to_yaml)