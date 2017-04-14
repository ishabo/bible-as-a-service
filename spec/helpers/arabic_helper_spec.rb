require "spec_helper"

RSpec.describe ArabicHelper do

  include ArabicHelper

  describe 'tashkeel' do
    it 'returns all tashkeel' do
      stub_const("ArabicHelper::FATHA", 'a')
      stub_const("ArabicHelper::DAMMA", 'u')
      stub_const("ArabicHelper::KASRA", 'i')
      stub_const("ArabicHelper::TANWEEN_AL_FATH", 'an')
      stub_const("ArabicHelper::TANWEEN_AL_DAM", 'un')
      stub_const("ArabicHelper::TANWEEN_AL_KASR", 'in')
      stub_const("ArabicHelper::SHADDA", '"')
      stub_const("ArabicHelper::SUKOON", 'o')

      expect(tashkeel).to eq 'auianunin"o'
    end
  end

  describe 'letter_alter' do

    before do
      stub_const("ArabicHelper::LETTER_ALTERS", {
          'a' => ['b', 'c', 'd']
      })
    end

    it 'returns an alternative letter if in the list' do
      expect(letter_alter 'a').to eq ['a', 'b', 'c', 'd']
    end

    it 'returns an the same letter letter if it is not in the list' do
      expect(letter_alter 'b').to eq ['b']
    end
  end
end
