require 'ostruct'
module Helper
  class SearchPattern
    attr_reader :language
    attr_accessor :patterns

    def initialize(language = 'English')
      @language = language == 'English' ? '\\w' : "\\p{#{language}}"
      @patterns =  {
                      reference:  { expression: /^([\w\s]+)\s+([\d]{1,3})\s*:?\s*([\d-]*)/i, match_keys: %w{full_match book chapter number} },
                      keyword:    { expression: /(whole|all|new_testament|nt|old_testament|ot|new|old*)?:?([#{@language}\s|]*)/i, match_keys: %w{full_match search_context search_keyword} }
                   }
    end

    def scan(keyword)
      @patterns.each do |keyword_type, regex|
        matches = keyword.match regex[:expression]
        return encapsulate keyword_type, regex[:match_keys], matches unless matches.nil?
      end
    end

    def encapsulate keyword_type, match_keys, matches
      matches = match_keys.zip(matches.to_a.map {|match| match.to_s.strip })
      return OpenStruct.new({keyword_type: keyword_type}.merge(Hash[matches]))
    end
  end
end
