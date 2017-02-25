module Bible
  # Verse module is a shared set of methods to be included by very
  # new versions class providing an interface functionality,
  # inheritable methods and a flexible way to connect to almost
  # identical collections
  module Verse
    extend ActiveSupport::Concern

    included do

      include Mongoid::Document
      field :bible_book_id, type: Integer
      field :chapter, type: Integer
      field :verse_number, type: Integer
      field :verse_text, type: String

      embedded_in :photographic, polymorphic: true

      scope :find_keyword, -> (keyword) do
        keyword = [keyword] unless keyword.kind_of?(Array)
        keyword.map! { |keyword| {verse_text: /.*#{keyword}.*/ } }
        where(keyword.count() > 1 ? {'$or' => keyword} : keyword[0])
      end

      default_scope -> { asc(:verse_number) }
      scope :find_chapter,   -> (chapter) { where(chapter: chapter) if chapter }
      scope :find_numbers,   -> (numbers) { where(verse_number: self.numbers_to_range(numbers) ) if numbers }

      def self.get_by_reference(book_title, chapter = nil, numbers = nil)
        book_id = Bible::Book.get_book_id book_title
        raise InvalidBookError.new(book_title) unless book_id
        where(bible_book_id: book_id).find_chapter(chapter).find_numbers(numbers)
      end

      def self.search(keyword, search_pattern = Bible::SearchPattern)
        match_result = search_pattern.new(pattern_language).scan(keyword)
        self.send("search_#{match_result.keyword_type}", match_result)
      end

      singleton_class.send(:alias_method, :main_search, :search)

      def self.search_keyword (match_result)
        search_keyword = self.ensure_keyword match_result.search_keyword
        find_keyword(self.prepare_keyword search_keyword)
      end

      def self.search_keyword_in_section (match_result)
        verses = self.search_keyword match_result
        self.search_in_section verses, match_result.search_context
      end

      def self.search_keyword_in_book (match_result)
        verses = self.search_keyword match_result
        self.search_in_book verses, match_result.search_context
      end

      def self.search_in_book (verses, search_context)
        unless search_context.empty?
          bible_book_ids = search_context.split(',').map { |book| Bible::Book.get_book_id(book) }
          verses = verses.and(bible_book_id: {"$in" => bible_book_ids})
        end
        verses
      end

      def self.search_in_section (verses, search_context)
        unless search_context.empty? || Bible::Testament.narrow_down_testament(search_context) == Bible::Testament::ALL
          bible_book_ids = Bible::Book.get_ids_by_testament(search_context)
          verses = verses.and(bible_book_id: {"$in" => bible_book_ids})
        end
        verses
      end

      def self.search_reference (match_result)
        self.get_by_reference(match_result.book, match_result.chapter, match_result.number)
      end

      def self.numbers_to_range numbers
        numbers = numbers.to_s.split('-').map(&:to_i).sort
        Range.new(numbers[0], numbers[-1])
      end

      def self.ensure_keyword keyword
        raise InvalidParamsError.new("No keyword provided") if keyword.empty?
        keyword
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
