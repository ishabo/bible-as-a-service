require "spec_helper"

RSpec.describe Bible::Verse do

  class Kjv
    include Bible::Verse
  end

  before do
    @version = Kjv
  end

  describe "#pattern_language" do
    it 'raises error if not implemented' do
      expect{@version.pattern_language}.to raise_error "Search patterns not implemented"
    end
  end

  describe "#prepare_keyword" do
    it 'implements basic keyword preperation method returning an array' do
      expect(@version.prepare_keyword 'God|is|Good').to eq ['God', 'is', 'Good']
      expect(@version.prepare_keyword 'Jesus').to eq ['Jesus']
      expect(@version.prepare_keyword 'Jesus Christ').to eq ['Jesus Christ']
    end
  end

  describe "#numbers_to_range" do
    it 'renders array of range' do
      expect(@version.numbers_to_range '1-4').to eq 1..4
      expect(@version.numbers_to_range '120-422').to eq 120..422
      expect(@version.numbers_to_range '0-2').to eq 0..2
    end
  end

  describe "#search_keyword" do
    before do
      #allow(@version).to receive_chane(:find_keyword).with(['Jesus Christ']).and_return({})
    end
  end
end
