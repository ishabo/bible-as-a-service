module Bible
  # This module is responsible for fetching bible book list and Book info
  # from MongoDB, giving methods that render a full list or a limited one
  # based on canon, testament or document type (i.e. epistle, historical etc.)
  class Book

    include Mongoid::Document

    field :title, type: String
    field :testament, type: String
    field :doc_type, type: String
    field :chapters, type: Integer
    field :canon_type, type: String
    field :canon_order, type: Integer
    field :full_name, type: Hash
    field :short_name, type: Hash
    field :abbr_name, type: Hash

    scope :old_testament_canonical, -> { where("$and" => [{testament: "old"}, {canon_type:  "canonical"}]) }
    scope :old_testament_all,       -> { where(testament: "old") }
    scope :new_testament_all,       -> { where(testament: "new") }
    scope :full_bible_all,          -> { where("$or" => [{testament: "old"}, {testament: "new"}]) }
    scope :new_testament,           -> { where(testament: "new") }
    scope :canonical,               -> { where(canon_type:  "canonical") }
    scope :order_by_id,             -> { asc(:_id) }
    scope :select_fields,           -> (fields) { only(fields) if fields }

    def self.get_list options = {}
      method = "#{Bible::Testament.detect_testament options[:testament]}_"
      method = "#{method}#{Bible::Canon.detect_canon_type (options[:canon_type] ||= 'all')}"
      list = Bible::Book.send(method)
      list = self.merge_apocrypha list.order_by_id.to_a
      list
    end

    def self.merge_apocrypha list
      list.map! do |book|
        add_book = find_additionals list, book[:title]
        book[:chapters] += add_book[:chapters] if add_book
        book
      end
      list_with_no_additionals list
    end

    def self.get_book_id book_title
      book = Bible::Book.only(:_id).where(:title => book_title.downcase.strip).first
      return unless book
      book._id
    end

    def self.get_ids_by_testament testament
      Bible::Book.get_list({testament: testament}).map {|field| field[:_id]}
    end

    private
    # To avoid nested looks in merge_apocrypha method
    def self.find_additionals list, title
      list.find {|apoc| apoc[:title] == "add_#{title}" }
    end

    # To avoid nested looks in merge_apocrypha method
    def self.list_with_no_additionals list
      list.delete_if {|book| book[:doc_type] == 'additional' }
      list
    end

    # This is a child of ruby StandardError
    # For customizing errors for absent books
    # When an attempt is made to fetch details
    # due to a typo, wrong identifier or missing
    # data from the database
    class InvalidBookError < StandardError
      def initialize (book)
        @book = book
      end

      def message
        "The Bible does not contain this book: #{@book}"
      end
    end

  end
end
