require "spec_helper"

RSpec.describe Bible::Versions::Asvd do

  before :all do
    @asvd = Bible::Versions::Asvd
  end

  describe "#get_by_reference" do
    context "when book is valid" do

      before :each do
        @book_title = 'genesis'
        allow(Bible::Book).to receive(:get_book_id).with(@book_title).and_return(1)
      end

      it "should render exactly 31 verses for genesis chapter 1" do
        expect(@asvd.get_by_reference(@book_title, 1).count()).to eq 31
      end

      it "should render exactly 31 verses for genesis chapter 1" do
        expect(@asvd.get_by_reference(@book_title, 1).count()).to eq 31
      end
    end

    context "when book is invalid" do
      before :each do
        @book_title = 'asheer'
        allow(Bible::Book).to receive(:get_book_id).with(@book_title).and_return(nil)
      end

      it "raises an exception" do
          expect{@asvd.get_by_reference(@book_title, 1)}.to raise_error InvalidBookError
      end
    end

  end

  def stub_search_type search_type, matches
    result = {
      keyword_type: search_type.to_s
    }.merge(matches)
    allow_any_instance_of(Bible::SearchPattern).to receive(:scan).with(matches[:full_match]).and_return(OpenStruct.new(result))
    allow(Bible::Book).to receive(:get_book_id).with(matches[:book]).and_return(1) if search_type == :reference
  end

  describe "#search" do

    context "when using a full reference" do
      context "when no verse number is provided" do
        it "should return all verses from the reference" do
          stub_search_type :reference, full_match: "Genesis 2", book: "Genesis", chapter: 2, number: nil
          genesis1 = @asvd.search("Genesis 2")
          expect(genesis1.count()).to eq 25
          expect(genesis1[20][:verse_number]).to eq 21
          expect(genesis1[24][:verse_number]).to eq 25
        end
      end

      context "when only one verse number is provided" do
        it "should return all verses from the reference" do
          stub_search_type :reference, full_match: "Genesis 3: 5", book: "Genesis", chapter: 3, number: 5
          genesis1 = @asvd.search("Genesis 3: 5")
          expect(genesis1.count()).to eq 1
          expect(genesis1[0][:verse_number]).to eq 5
        end
      end

      context "when a range of verses are provided" do
        it "should return all verses from the reference" do
          stub_search_type :reference, full_match: "Genesis 50: 2-10", book: "Genesis", chapter: "50", number: "2-10"
          genesis1 = @asvd.search("Genesis 50: 2-10")
          expect(genesis1.count()).to eq 9
          expect(genesis1[0][:verse_number]).to eq 2
          expect(genesis1[8][:verse_number]).to eq 7
        end
      end

      it "should return a full chapter with highlight on verse if successful" do
        #@asvd.search("Genesis 1: 5")
      end

      it "should return a standard error" do
        #@asvd.search("Asher 1")
      end
    end


    shared_examples_for "keyword search" do |keyword, exact_or_any, search_context, expected_matches|
      #puts "-------------------------#{keyword.inspect}"
      context "when using #{exact_or_any} match" do
        it "should return all or zero matches within #{search_context} for #{keyword}" do
          stub_search_type :keyword, full_match: "#{search_context}:#{keyword}", search_context: search_context, search_keyword: keyword
          genesis1 = @asvd.search("#{search_context}:#{keyword}").count()
          expect(genesis1).to eq expected_matches
        end
      end
    end

    context "when using a keyword" do


      context "when searching the whole bible" do
        it_should_behave_like "keyword search", METHUSELAH, "exact", "whole", 7
        it_should_behave_like "keyword search", GOD_IS_GOOD, "exact", "whole", 7
        it_should_behave_like "keyword search", JESUS_OR_JOSHUA, "any", "whole", 1168
        it_should_behave_like "keyword search", MARANATHA, "exact", "whole", 1
        it_should_behave_like "keyword search", FALSE_PROPHET, "exact", "whole", 0
        it_should_behave_like "keyword search", MAHER_SHALAL_HASH_BAZ, "exact", "whole", 2
      end

      context "when searching the old testament" do
        it_should_behave_like "keyword search", METHUSELAH, "exact", "old_testament", 6
        it_should_behave_like "keyword search", GOD_IS_GOOD, "exact", "old_testament", 6
        it_should_behave_like "keyword search", JESUS_OR_JOSHUA, "any", "old_testament", 234
        it_should_behave_like "keyword search", MARANATHA, "exact", "old_testament", 0
        it_should_behave_like "keyword search", FALSE_PROPHET, "exact", "old_testament", 0
        it_should_behave_like "keyword search", MAHER_SHALAL_HASH_BAZ, "exact", "old_testament", 2
      end

      context "when searching the new testament" do
        it_should_behave_like "keyword search", METHUSELAH, "exact", "new_testament", 1
        it_should_behave_like "keyword search", GOD_IS_GOOD, "exact", "new_testament", 1
        it_should_behave_like "keyword search", JESUS_OR_JOSHUA, "any", "new_testament", 934
        it_should_behave_like "keyword search", MARANATHA, "exact", "new_testament", 1
        it_should_behave_like "keyword search", FALSE_PROPHET, "exact", "new_testament", 0
        it_should_behave_like "keyword search", MAHER_SHALAL_HASH_BAZ, "exact", "new_testament", 0
      end
    end
  end
end
