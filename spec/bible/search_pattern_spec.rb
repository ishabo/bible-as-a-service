require "spec_helper"

RSpec.describe Bible::SearchPattern do
  describe "#new" do
    it "initializes with English by default" do
      expect(Bible::SearchPattern.new().language).to eq "\\w"
    end

    it "initializes with Arabic" do
      expect(Bible::SearchPattern.new('Arabic').language).to eq "\\p{Arabic}"
    end
  end

  describe "#analyse" do
    context "analysing reference patterns" do
      shared_examples_for "reference" do |book, chapter, number = ""|
        context "When analysing references #{number.empty? ? 'without' : 'with'} number" do
          before do
            @pattern = Bible::SearchPattern.new('English').scan("#{book} #{chapter}#{':' unless number.empty?}#{number}")
          end

          it "knows it's a reference search" do
            expect(@pattern.keyword_type).to eq :reference
          end

          it "matches book title" do
            expect(@pattern.book).to eq book.strip
          end

          it "matches book chapter" do
            expect(@pattern.chapter).to eq chapter.strip
          end

          it "matches #{number.empty? ? 'matches' : 'does not match'} number" do
            expect(@pattern.number).to eq number.strip
          end
        end
      end

      it_behaves_like "reference", "Genesis", "2", "1"
      it_behaves_like "reference", "exudos", "2", "5"
      it_behaves_like "reference", "1 Sameul", "2"
      it_behaves_like "reference", "1 Kings", "10"
      it_behaves_like "reference", "Psalm", "150"
      it_behaves_like "reference", "1John", " 1 "
      it_behaves_like "reference", "2John", " 1 ", " 3 "
    end

    context "analysing keyword patterns" do
      shared_examples_for "keyword" do |language, search_context, keyword, detected_keyword, search_context_method |
        context "When analysing keywords #{search_context.empty? ? 'without' : 'with'} testament" do
          before do
            separator = search_context.empty? ? ':' : ''
            @pattern = Bible::SearchPattern.new(language).scan("#{search_context}#{separator}#{keyword}")
          end

          it "knows it's a keyword search" do
            expect(@pattern.keyword_type).to eq(search_context_method)
          end

          it "matches testament" do
            expect(@pattern.search_context).to eq(search_context.present? ? search_context : detected_keyword)
          end

          it "matches keyword" do
            expect(@pattern.search_keyword).to eq(search_context.present? ? detected_keyword : '')
          end
        end
      end

      it_behaves_like 'keyword', 'Arabic', 'new_testament', MARANATHA, MARANATHA, :keyword_in_section
      it_behaves_like 'keyword', 'Arabic', 'nt', JESUS_OR_JOSHUA, JESUS_OR_JOSHUA, :keyword_in_section
      it_behaves_like 'keyword', 'Arabic', 'old', FALSE_PROPHET, FALSE_PROPHET, :keyword_in_section
      it_behaves_like 'keyword', 'Arabic', 'sads', FALSE_PROPHET, FALSE_PROPHET, :keyword_in_book
      it_behaves_like 'keyword', 'English', 'old_testament', METHUSELAH, '', :keyword_in_section
      it_behaves_like 'keyword', 'Arabic', 'whole', ' asd as das ', '', :keyword_in_section
      it_behaves_like 'keyword', 'English', '', ' asdsdas ', 'asdsdas',  :keyword_in_book
    end
  end
end
