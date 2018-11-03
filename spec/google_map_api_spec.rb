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
      place = ServiceMap::GoogleMap::PointMapper.new(MAP_KEY).find(SEARCH_PLACE)
      _(place.origin_id).must_equal CORRECT[0]['candidates'][0]['place_id']
    end

    it 'SAD: should raise exception on blank searching place' do
      proc do
        ServiceMap::GoogleMap::PointMapper.new(MAP_KEY).find('')
      end.must_raise ServiceMap::GoogleMap::Api::Response::InvalidRequest
    end

    it 'SAD: should raise exception when unauthorized' do
      proc do
        ServiceMap::GoogleMap::PointMapper.new('BAD_KEY')
                                          .find(SEARCH_PLACE)
      end.must_raise ServiceMap::GoogleMap::Api::Response::RequestDenied
    end
  end

  describe 'Place Details' do
    before do
      @place = ServiceMap::GoogleMap::PointMapper.new(MAP_KEY)
                                                 .find(SEARCH_PLACE)
    end

    it 'HAPPY: should recognize searching place' do
      details = ServiceMap::GoogleMap::DetailsMapper
                .new(MAP_KEY, @place.origin_id)
                .load_details
      _(details.name).must_equal CORRECT[1]['result']['name']
    end
  end
end
