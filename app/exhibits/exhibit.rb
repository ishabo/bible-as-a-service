require 'deligate'
class Exhibit < SimpleDeligator
  def initialize(data)
    @result = {}
    @result[:version] = 1.0
    @data = data
  end

  def to_json
    @result.to_json
  end
end
