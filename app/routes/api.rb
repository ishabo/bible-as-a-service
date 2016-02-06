module Bible

  class Application < Sinatra::Base

    include ExhibitHelper

    before do
      content_type :json, 'charset' => 'utf-8'
    end

    get "/api/:api_version/book_list/?:testament?/?:canon_type?" do
      exhibit Bible::Book.get_list(params), :json
    end

    get "/api/:api_version/full_book/:book" do
      exhibit version.get_by_reference(params[:book])
    end

    get "/api/:api_version/book_chapter/:book/:chapter" do
      exhibit version.get_by_reference(params[:book], params[:chapter])
    end

    get "/api/:api_version/ref/:book/:chapter/:numbers" do
      exhibit version.get_by_reference(params[:book], params[:chapter], params[:numbers])
    end

    get "/api/:api_version/search/:context/:keyword" do
      content_type :json, 'charset' => 'utf-8'
      exhibit version.search("#{params[:context]}:#{URI.unescape params[:keyword]}")
    end

    def version
      params[:version] ||= 'asvd'
      bible_versions = Bible::Version.new
      bible_versions.load(params[:version])
    end
  end
end
