module Bible

  class Application < Sinatra::Base

    before do
      content_type :json, 'charset' => 'utf-8'
    end

    get "/api/:api_version/book_list/:testament/:canon_type" do
      Service.new(Bible::Book.get_list(params)).display
    end

    get "/api/:api_version/full_book/:book" do
      Service.new(version.get_by_reference(params[:book])).display
    end

    get "/api/:api_version/book_chapter/:book/:chapter" do
      Service.new(version.get_by_reference(params[:book], params[:chapter])).display
    end

    get "/api/:api_version/ref/:book/:chapter/:numbers" do
      Service.new(version.get_by_reference(params[:book], params[:chapter], params[:numbers])).display
    end

    get "/api/:api_version/search/:context/:keyword" do
      Service.new(version.search("#{params[:context]}:#{URI.unescape(Helper::Arabic.encode params[:keyword])}")).display
    end

    def version
      params[:version] ||= 'asvd'
      bible_versions = Bible::Version.new
      bible_versions.load(params[:version])
    end
  end
end
