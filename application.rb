require 'uri'
require_relative './app/routes/api'

module Bible

  class Application < Sinatra::Base
    set :root, File.dirname(__FILE__)

    get '/' do
      
    end

  end
end

class Service

  def initialize(result)
    @json = {}
    @json[:version] = 1.0
    begin
      @json[:data] = result
    rescue Exception => e
       @json[:message] = e.message
    end

  end

  def display
    @json.to_json
  end
end
