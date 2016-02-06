class InvalidParamsError < StandardError
  def initialize (params)
    @params = params
  end

  def message
    "Something seems to be wrong with the parameters: #{@params.inspect}"
  end
end
