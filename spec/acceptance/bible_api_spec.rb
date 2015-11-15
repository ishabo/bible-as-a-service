require "spec_helper"
require "./app/bible_api"

RSpec.describe BibleApi::Application do

  def app
    BibleApi::Application
  end

  def parse_body debug = false
    json = JSON.parse(last_response.body) #, :symbolize_names => true
    abort json.inspect if debug
    return json["data"] if json.has_key? "data"
    return json["message"] if json.has_key? "message"
  end

  describe "GET bible books" do
    # context "no bible" do
    #   it "returns no bible list" do
    #     get "/"
    #     parse_body = JSON.parse(last_response.body)
    #     expect(parse_body).to have_key(:ar)
    #     expect(last_response.status).to eq 200
    #   end
    # end

    context "when old testament" do
      context "and only canonical is requested" do
        it "returns 39 books" do
          get "/api/book_list/old_testament/canonical"
          expect(parse_body.count).to eq(39)
        end

      end
      context "and apocryphal are included" do
        it "returns 46 books" do
          get "/api/book_list/old_testament/all"
          #abort parse_body.inspect
          expect(parse_body.count).to eq(46)
        end
      end
    end
  end

  describe "Get Full Bible" do
    it "returns the full book account of genesis" do
      get "/api/full_book/genesis"
      expect(parse_body.count).to eq(1533)
    end

    it "returns the full book account of revelation" do
      get "/api/full_book/revelation"
      expect(parse_body.count).to eq(404)
    end
  end

  describe "GET bible chapters" do

    it "returns the specified chapter only" do
      get "/api/book_chapter/genesis/1"
      expect(parse_body.count).to eq(31)
    end
  end

  describe "Get Bible Reference" do
    it "returns the specified bible reference for 1 verse number" do
      get "/api/ref/genesis/1/1"
      expect(parse_body.count()).to eq(1)
      expect(parse_body[0]["verse_text"]).to eq("فِي الْبَدْءِ خَلَقَ اللهُ السَّمَاوَاتِ وَالأَرْضَ.")
    end

    it "returns the specified bible reference for 2 verses" do
      get "/api/ref/genesis/1/1-2"
      expect(parse_body.count()).to eq(2)
      expect(parse_body[0]["verse_text"]).to eq("فِي الْبَدْءِ خَلَقَ اللهُ السَّمَاوَاتِ وَالأَرْضَ.")
      expect(parse_body[1]["verse_text"]).to eq("وَكَانَتِ الأَرْضُ خَرِبَةً وَخَالِيَةً، وَعَلَى وَجْهِ الْغَمْرِ ظُلْمَةٌ، وَرُوحُ اللهِ يَرِفُّ عَلَى وَجْهِ الْمِيَاهِ.")
    end
  end
end