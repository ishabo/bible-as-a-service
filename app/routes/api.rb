module Bible

  class Application < Sinatra::Base

    get "/api/book_list/:testament/:canon_type" do
      content_type :json
      Service.new(Bible::Book.get_list(params)).display
    end

    get "/api/full_book/:book/?:version" do
      content_type :json
      Service.new(bible.get_by_reference(params[:book])).display
    end

    get "/api/book_chapter/:book/:chapter" do
      content_type :json
      Service.new(bible.get_by_reference(params[:book], params[:chapter])).display
    end

    get "/api/ref/:book/:chapter/:numbers" do
      content_type :json
      Service.new(bible.get_by_reference(params[:book], params[:chapter], params[:numbers])).display
    end

    get "/api/search/:context/:keyword" do
      content_type :json

      Service.new(bible.search("#{params[:context]}:#{URI.unescape(Helper::Arabic.encode params[:keyword])}")).display
    end

    def bible
      params[:version] ||= 'asvd'
      bible_versions = Bible::Version.new
      bible_versions.load(params[:version])
    end
  end
end
