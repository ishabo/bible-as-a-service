require 'uri'
require_relative './app/routes/api'

module Bible

  class Application < Sinatra::Base

    set :root, File.dirname(__FILE__)

    get '/' do

    end
  end
end
