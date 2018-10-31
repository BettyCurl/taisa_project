require_relative 'spec_helper.rb'

describe 'Tests DataCollection Library' do
  VCR.configure do |config|
    config.cassette_library_dir = CASSETTES_FOLDER
    config.hook_into :webmock # or :fakeweb

    config.filter_sensitive_data('<GOOGLE_MAP_KEY>') { MAP_KEY }
    config.filter_sensitive_data('<GOOGLE_MAP_ESC>') { CGI.escape(MAP_KEY) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                    record: :new_episodes,
                    match_requests_on: %i[method uri headers]
  end

  after do 
    VCR.eject_cassette 
  end

  describe 'Access Place ID' do
    it 'HAPPY: should provide correct place ID' do
      place = DataCollection::GoogleMapAPI.new(MAP_KEY).search_place(SEARCH_PLACE)
      _(place.place_id).must_equal CORRECT[0]['candidates'][0]['place_id']
      _(place.url).must_equal CORRECT[0]['url']
    end
  

    it 'SAD: should raise exception on blank searching place' do
      proc do 
      DataCollection::GoogleMapAPI.new(MAP_KEY).search_place('')
      end.must_raise DataCollection::GoogleMapAPI::Errors::INVALID_REQUEST
    end

    it 'SAD: should raise exception when unauthorized' do
      proc do
        DataCollection::GoogleMapAPI.new('BAD_KEY').search_place(SEARCH_PLACE)
      end.must_raise DataCollection::GoogleMapAPI::Errors::REQUEST_DENIED
    end
  end

  describe 'Place Details' do
    before do
      @place = DataCollection::GoogleMapAPI.new(MAP_KEY).search_place(SEARCH_PLACE)
    end

    it 'HAPPY: should recognize searching place' do
      details = DataCollection::GoogleMapAPI.new(MAP_KEY).place_details(@place.place_id, DETAILS_ITMES)
      _(details.url).must_equal CORRECT[1]['url']
      _(details.name).must_equal CORRECT[1]['result']['name']
    end  
  end

end