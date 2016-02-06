require 'bundler/setup'

Bundler.require(:default)
Mongoid.load!("./config/mongoid.yml", ENV['RACK_ENV'].to_sym || :development )

VERSIONS_DIR = './app/bible/versions'

list_to_require = Dir["./app/helpers/*.rb"] +
                  Dir["./app/bible/errors/*.rb"] +
                  Dir["./app/bible/*.rb"] +
                  Dir["./app/bible/versions/*.rb"] +

                  Dir["#{VERSIONS_DIR}/*.rb"] +
                  Dir["./application.rb"]

list_to_require.each {|file| require_relative file }

map '/' do
  run Rack::URLMap.new("/" => Bible::Application)
end
