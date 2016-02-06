require 'uri'
require_relative './app/routes/api'

module Bible

  class Application < Sinatra::Base
    register Hatchet
    set :root, File.dirname(__FILE__)

    get '/' do

    end

    configure do
      db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'bible')
      set :mongo_db, db[:test]
    end

    configure :development do
      Hatchet.configure do |config|
        config.level :debug
      end
    end

  end
end
