require 'bundler/setup'

Bundler.require(:default)
Mongoid.load!("./config/mongoid.yml", ENV['RACK_ENV'].to_sym || :development )

VERSIONS_DIR = './lib/bible/versions'


#Dir["./app/*.rb"].each {|file| require file }
Dir["./lib/helpers/*.rb"].each {|file| require file }
Dir["./lib/bible/*.rb"].each {|file| require file }
Dir["#{VERSIONS_DIR}/*.rb"].each {|file| require file }
Dir["./application.rb"].each {|file| require file }

map '/' do
  run Rack::URLMap.new("/" => Bible::Application)
end
