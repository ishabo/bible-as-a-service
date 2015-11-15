module Bible
  module Verse

    extend ActiveSupport::Concern

    included do

      include Mongoid::Document
      field :bible_book_id, type: Integer
      field :chapter, type: Integer
      field :verse_number, type: Integer
      field :verse_text, type: String

      scope :find_keyword, -> (keyword) do
        keyword = [keyword] unless keyword.kind_of?(Array)
        keyword.map! { |keyword| {verse_text: /.*#{keyword}.*/ } }
        where(keyword.count() > 1 ? {'$or' => keyword} : keyword[0])
      end

      scope :order_by_id,    -> { asc(:verse_number) }
      scope :find_numbers,   -> (numbers) { where(verse_number: self.numbers_to_range(numbers) ) unless numbers.nil? }

      def self.get_by_reference(book_title, chapter = nil, numbers = nil)
        book_id = Bible::Book.get_book_id book_title.strip
        return [] unless book_id
        verses = where(bible_book_id: book_id)
        if chapter
          verses = verses.where(chapter: chapter)
          verses = verses.find_numbers(numbers) if numbers
        end
        verses
      end

      def self.search(keyword, search_pattern = Helper::SearchPattern)
        keyword_type, matches = search_pattern.new(pattern_language).scan(keyword)
        self.send("search_#{keyword_type}", matches)
      end

      def self.search_keyword (matches)
        keyword = self.validate_keyword(matches)
        verses = find_keyword(self.prepare_keyword keyword)
        verses = verses.and(bible_book_id: {"$in": Bible::Book.get_ids_by_testament(matches[1])}) unless matches[1].nil? || Helper::Testament.narrow_down_testament(matches[1]) == Helper::Testament::ALL
        verses
      end

      def self.search_reference (matches)
        self.get_by_reference(matches[1].strip, matches[2], matches[3])
      end

      def self.validate_keyword (matches)
        keyword = matches[2]
        raise "No keyword provided" if keyword.empty?
        keyword
      end

      def self.numbers_to_range numbers
        numbers = numbers.to_s.split('-').map(&:to_i).sort
        Range.new(numbers[0], numbers[-1])
      end

      #Interface methods
      def self.pattern_language
        raise "Search patterns not implemented"
      end

      def self.prepare_keyword keyword
        keyword.split('|')
      end
    end
  end
end
