module Bible
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
      options[:canon_type] ||= 'all'
      method = "#{Helper::Testament.detect_testament options[:testament]}_"
      method = "#{method}#{Helper::Canon.detect_canon_type options[:canon_type]}"
      list = Bible::Book.send(method)
      list = self.merge_apocrypha list.order_by_id.to_a
      list
    end

    def self.merge_apocrypha list
      list.map! do |book|
        add_book = list.find {|apoc| apoc[:title] == "add_#{book[:title]}" }
        book[:chapters] += add_book[:chapters] if add_book
        book
      end

      list.delete_if {|book| book[:doc_type] == 'additional' }
      list
    end

    def self.get_book_id book_title
      book = Bible::Book.only(:_id).where(:title => book_title.downcase).first
      return book._id if book
      nil
    end

    def self.get_ids_by_testament testament
      Bible::Book.get_list({testament: testament}).map {|field| field[:_id]}
    end

  end
end
