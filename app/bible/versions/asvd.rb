module Bible
  module Versions
    class Asvd
      include Bible::Verse
      extend ArabicHelper

      store_in collection: 'bible_asvd_verses'

      def self.search(keyword)
        super_search(encode keyword)
      end

      def self.pattern_language
        'Arabic'
      end

      def self.prepare_keyword keyword

        alt = lambda do |c|
          letters = letter_alter(c)
          "[#{letters.join('')}]{1}"
        end

        keyword.split('|').map! do |k|
          k.scan(/./)
              .map(&alt)
              .join("[#{tashkeel}]{0,2}")
        end
      end
    end
  end
end