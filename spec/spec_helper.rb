require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'
include WebMock::API
WebMock.enable!

require_relative '../lib/google_map_api.rb'

SEARCH_PLACE = 'Taipei%20Main%20Station'.freeze
PLACE_ID = 'ChIJcYy0Y3KpQjQRXiW_s2lGln8'.freeze
DETAILS_ITMES = 'name,rating,formatted_address'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
MAP_KEY = CONFIG['MAP_KEY']
CORRECT = YAML.safe_load(File.read('spec/fixtures/map_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'google_map_api'.freeze
