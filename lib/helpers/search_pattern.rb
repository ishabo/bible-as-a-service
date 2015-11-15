module Helper
  class SearchPattern
    attr_reader :language
    attr_accessor :patterns

    def initialize(language = 'English')
      @language = language == 'English' ? '\\w' : "\\p{#{language}}"
      @patterns =  {
          reference: /^([\w\s]+)\s+([\d]{1,3})\s*:?\s*([\d-]*)/i,
          keyword: /(whole|all|new_testament|nt|old_testament|ot|new|old*)?:?([#{@language}\s|]*)/i #
        }
    end

    def scan(keyword)
      @patterns.each do |keyword_type, regex|
        matches = keyword.match regex
        return [keyword_type, matches.to_a.map {|match| match.to_s.strip }] unless matches.nil?
      end
    end
  end
end
