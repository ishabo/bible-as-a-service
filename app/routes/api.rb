module Bible

  class Application < Sinatra::Base

    include ExhibitHelper

    before do
      content_type :json, 'charset' => 'utf-8'
    end

    get "/api/:api_version/:lang/book_list/?:testament?/?:canon_type?" do
      exhibit Bible::Book.get_list(params), :json
    end

    get "/api/:api_version/:lang/full_ref/:ref" do
      ref = URI.decode(params[:ref]).split('_')
      book, chapter, number = ref
      book = Bible::Book.guess_book book, params[:lang].to_sym
      exhibit book ? version.get_by_reference(book.title, chapter, number) : {}
    end

    get "/api/:api_version/:lang/book_info/:book_name" do
      book_name = URI.decode(params[:book_name])
      exhibit Bible::Book.guess_book book_name, params[:lang].to_sym
    end

    get "/api/:api_version/:lang/full_book/:book" do
      exhibit version.get_by_reference(params[:book])
    end

    get "/api/:api_version/:lang/book_chapter/:book/:chapter" do
      exhibit version.get_by_reference(params[:book], params[:chapter])
    end

    get "/api/:api_version/:lang/ref/:book/:chapter/:numbers" do
      exhibit version.get_by_reference(params[:book], params[:chapter], params[:numbers])
    end

    get "/api/:api_version/:lang/search/:context/:keyword" do
      content_type :json, 'charset' => 'utf-8'
      exhibit version.search("#{params[:context]}:#{URI.unescape params[:keyword]}")
    end

    def version
      params[:version] ||= 'asvd'
      params[:lang] ||= 'en'
      bible_versions = Bible::Version.new
      bible_versions.load(params[:version])
    end
  end
end
