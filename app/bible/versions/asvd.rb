module Bible
  module Versions
    class Asvd
      include Bible::Verse

      store_in collection: "bible_asvd_verses"

      def self.pattern_language
        'Arabic'
      end

      def self.prepare_keyword keyword
        keyword.split('|').map! { |keyword| keyword.scan(/./).join("[#{Helper::Arabic.tashkeel}]{0,2}") }
      end
    end
  end
end
