require "spec_helper"

RSpec.describe Helper::SearchPattern do
  describe "#new" do
    it "initializes with English by default" do
      expect(Helper::SearchPattern.new().language).to eq "\\w"
    end

    it "initializes with Arabic" do
      expect(Helper::SearchPattern.new('Arabic').language).to eq "\\p{Arabic}"
    end
  end

  describe "#analyse" do
    context "analysing reference patterns" do
      shared_examples_for "reference" do |book, chapter, number = ""|
        context "When analysing references #{number.empty? ? 'without' : 'with'} number" do
          before do
            @pattern = Helper::SearchPattern.new('English').scan("#{book} #{chapter}#{':' unless number.empty?}#{number}")
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
      shared_examples_for "keyword" do |language, testament_context, detect_testament, keyword, detect_keyword |
        context "When analysing keywords #{testament_context.empty? ? 'without' : 'with'} testament" do
          before do
            @pattern = Helper::SearchPattern.new(language).scan("#{testament_context}#{':' unless testament_context.empty?}#{keyword}")
          end

          it "knows it's a keyword search" do
            expect(@pattern.keyword_type).to eq :keyword
          end

          it "matches testament" do
            expect(@pattern.search_context).to eq (detect_testament ? testament_context : "")
          end

          it "matches keyword" do
            expect(@pattern.search_keyword).to eq (detect_keyword ? keyword.strip : "")
          end
        end
      end

      it_behaves_like "keyword", "Arabic", "new_testament", true, MARANATHA, true
      it_behaves_like "keyword", "Arabic", "nt", true, JESUS_OR_JOSHUA, true
      it_behaves_like "keyword", "Arabic", "old", true, FALSE_PROPHET, true
      it_behaves_like "keyword", "Arabic", "blabla", false, FALSE_PROPHET, false
      it_behaves_like "keyword", "English", "old_testament", true, METHUSELAH, false
      it_behaves_like "keyword", "Arabic", "whole", true, " asd as das ", false
      it_behaves_like "keyword", "English", "", true, " asdsdas ", true
    end
  end
end
