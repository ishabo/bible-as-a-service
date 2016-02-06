module Bible
  # This module is responsible for fetching bible book list and Book info
  # from MongoDB, giving methods that render a full list or a limited one
  # based on canon, testament or document type (i.e. epistle, historical etc.)
  class Book

    include Mongoid::Document
    include Hatchet

    ADDITIONAL = 'additional'
    CANONICAL = 'canonical'
    ALL = 'all'

    store_in collection: "bible_books"

    field :title, type: String
    field :testament, type: String
    field :doc_type, type: String
    field :chapters, type: Integer
    field :canon_type, type: String
    field :canon_order, type: Integer
    field :full_name, type: Hash
    field :short_name, type: Hash
    field :abbr_name, type: Hash

    scope :old_testament_canonical, -> { where("$and" => [{testament: Bible::Testament::OLD}, {canon_type:  CANONICAL}]) }
    scope :old_testament_all,       -> { where(testament: Bible::Testament::OLD) }
    scope :new_testament_all,       -> { where(testament: Bible::Testament::NEW) }
    scope :full_bible_all,          -> { where("$or" => [{testament: Bible::Testament::OLD}, {testament: Bible::Testament::NEW}]) }
    scope :new_testament,           -> { where(testament: Bible::Testament::NEW) }
    scope :canonical,               -> { where(canon_type:  CANONICAL) }
    scope :order_by_id,             -> { asc(:_id) }
    scope :select_fields,           -> (fields) { only(fields) if fields }

    def self.get_list options = {}
      begin
        list = send(prep_scope_method options)
        self.merge_apocrypha list.to_a
      rescue => e
        raise InvalidParamsError.new options
      end
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
      book = only(:_id).find_by(:title => book_title.downcase.strip)
      return unless book
      book._id
    end

    def self.get_ids_by_testament testament
      get_list({testament: testament}).map {|field| field[:_id]}
    end

    private
    # To avoid nested looks in merge_apocrypha method
    def self.find_additionals list, title
      list.find {|apoc| apoc[:title] == "add_#{title}" }
    end

    # To avoid nested looks in merge_apocrypha method
    def self.list_with_no_additionals list
      list.delete_if {|book| book[:doc_type] == ADDITIONAL }
      list
    end

    def self.prep_scope_method options
      method = "#{Bible::Testament.detect_testament options[:testament]}_"
      method = "#{method}#{(options[:canon_type] ||= ALL)}"
      method
    end
  end
end
