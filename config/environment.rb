require 'roda'
require 'yaml'

module ServiceMap
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    GM_KEY = CONFIG['GM_KEY']
  end
end