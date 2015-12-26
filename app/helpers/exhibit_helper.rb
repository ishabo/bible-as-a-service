module ExhibitHelper
  def exhibit (result, format = 'json')
    service = Service.new(result)
    begin
      service.send("to_#{format}")
    rescue e
      raise "Perhaps you've provided the wrong format? - #{e.message}"
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

  def to_json
    @json.to_json
  end

  def to_xml
    @json.to_xml
  end

end
