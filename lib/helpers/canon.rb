module Helper
  class Canon
    ALL = 'all'
    CANONICAL = 'canonical'

    def self.detect_canon_type canon_type
      return CANONICAL if %w(canon canonized canonical).include? canon_type
      return ALL
    end

    def self.canon_type_valid? canon_type
      %w(apocryphal canonical all).include? canon_type
    end
  end
end
