require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init.rb'

SEARCH_PLACE = 'Taipei%20Main%20Station'.freeze
PLACE_ID = 'ChIJcYy0Y3KpQjQRXiW_s2lGln8'.freeze
DETAILS_ITMES = 'name,rating,formatted_address'.freeze
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
GM_KEY = CONFIG['GM_KEY']
CORRECT = YAML.safe_load(File.read('spec/fixtures/map_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
CASSETTE_FILE = 'google_map_api'.freeze
