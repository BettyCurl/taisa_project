require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/google_map_api.rb'

describe 'Tests DataCollection Library' do
  
  SEARCH_PLACE = 'Taipei%20Main%20Station'

  CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
  MAP_KEY = CONFIG['MAP_KEY']
 
  CORRECT = YAML.safe_load(File.read('fixtures/map_results.yml'))
  #RESPONSE = YAML.safe_load(File.read('fixtures/map_response.yml'))

  describe 'Access Place ID' do
    it 'HAPPY: should provide correct place ID' do
      place = DataCollection::GoogleMapAPI.new(MAP_KEY).search_place(SEARCH_PLACE)
      _(place.place_id).must_equal CORRECT['place_id']
      _(place.url).must_equal CORRECT['place_url']
    end

    #it 'SAD: should raise exception on blank searching place' do
    #  proc do 
    #    DataCollection::GoogleMapAPI.new(MAP_KEY).search_place('')
    #  end.must_raise DataCollection::GoogleMapAPI::Errors::INVALID_REQUEST
    #end

    #it 'SAD: should raise exception when unauthorized' do
    #  proc do
    #    DataCollection::GoogleMapAPI.new('BAD_KEY').search_place(SEARCH_PLACE)
    #  end.must_raise DataCollection::GoogleMapAPI::Errors::REQUEST_DENIED
    #end
  end

  describe 'Place Details' do
    before do
      @place = DataCollection::GoogleMapAPI.new(MAP_KEY).search_place(SEARCH_PLACE)
    end

    it 'HAPPY: should recognize searching place' do
      details = DataCollection::GoogleMapAPI.new(MAP_KEY).place_details(@place.place_id)
      _(details.url).must_equal CORRECT['details_url']
      _(details.name).must_equal CORRECT['name']
    end  
  end

end