require "spec_helper"

RSpec.describe Bible::Book do

  describe "#get_book_id" do
    it "finds the id of genesis" do
      expect(Bible::Book.get_book_id 'genesis').to eq 1
    end

    it "is case-insensitive" do
      expect(Bible::Book.get_book_id 'GenesIs').to eq 1
    end

    it "finds the id of matthew" do
      expect(Bible::Book.get_book_id 'matthew').to eq 50
    end

    it "finds the id of revelation" do
      expect(Bible::Book.get_book_id 'revelation').to eq 76
    end

    it "doesn't find the id when title isn't valid" do
      expect(Bible::Book.get_book_id '3peter').to eq nil
    end
  end

  describe "#get_list" do
    it "test get_list with canon option"
    it "returns new testament ids" do
       expect(Bible::Book.get_list({testament: 'new_testament'}).map {|field| field[:_id]}).to eq [50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76]

    end

    it "returns old testament ids" do
      expect(Bible::Book.get_list({testament: 'old_testament'}).map {|field| field[:_id]}).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49]
    end
  end

  describe "#merge_apocrypha" do
    let(:list) {
      [
        {
          :_id => 1,
          :title => "daniel",
          :chapters => 11,
          :doc_type => "book",
          :canon_type => "canonical",
        },
        {
          :_id => 2,
          :title => "add_daniel",
          :chapters => 3,
          :doc_type => "additional",
          :canon_type => "apocryphal",
        },
        {
          :_id => 3,
          :title => "esther",
          :chapters => 10,
          :doc_type => "book",
          :canon_type => "canonical",
        },
        {
          :_id => 4,
          :title => "add_esther",
          :chapters => 6,
          :doc_type => "additional",
          :canon_type => "apocryphal",
        },
        {
          :_id => 5,
          :title => "tobith",
          :chapters => 6,
          :doc_type => "book",
          :canon_type => "apocryphal",
        },
      ]
    }

    context "when 2 documents are additions" do
      it "renders 3 with doc_type book" do
        merged_list = Bible::Book.merge_apocrypha list
        expect(merged_list.select{|l| l[:doc_type] == 'book'}.count()).to eq 3
      end

      it "leaves the apocryphal book which is not additional" do
        merged_list = Bible::Book.merge_apocrypha list
        expect(merged_list.select{|l| l[:canon_type] == 'apocryphal'}.count()).to eq 1
      end
    end
  end

  describe "#get_books_by_testament" do
    context "when it's new testament" do

    end

    context "when it's old testament" do

    end
  end
end
