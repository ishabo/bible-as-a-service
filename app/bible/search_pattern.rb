require 'ostruct'
module Bible
  # SearchPattern analyses a set of regular expression pattern
  # when a search query is made and encapsulate results
  class SearchPattern
    attr_reader :language

    def initialize(language = 'English')
      @language = language == 'English' ? '\\w' : "\\p{#{language}}"
      @patterns =  {
                      reference:              { expression: /^([\w\s]+)\s+([\d]{1,3})\s*:?\s*([\d-]*)/i, match_keys: %w{full_match book chapter number} },
                      keyword_in_section:     { expression: /(whole|all|new_testament|nt|old_testament|ot|new|old*):?([#{@language}\s\|]*)/i, match_keys: %w{full_match search_context search_keyword} },
                      keyword_in_book:        { expression: /([\w,]+):?([#{@language}\s|]*)/i, match_keys: %w{full_match search_context search_keyword} }
      }
    end

    # scan takes on a string parameter and returns the first pattern detected
    # @param keyword string
    # @return OpenStruct object
    def scan(keyword)
      @patterns.each do |keyword_type, regex|
        matches = keyword.match regex[:expression]
        return SearchPattern.encapsulate keyword_type, regex[:match_keys], matches if matches
      end
    end

    # encapsulate match data from the scan method
    # @param keyword_type symbol
    # @param match_keys array
    # @param matches array
    # @return OpenStruct object
    def self.encapsulate keyword_type, match_keys, matches
      matches = match_keys.zip(matches.to_a.map {|match| match.to_s.strip })
      return OpenStruct.new({keyword_type: keyword_type}.merge(Hash[matches]))
    end
  end
end
