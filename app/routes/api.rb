module Bible

  class Application < Sinatra::Base

    get "/api/book_list/:testament/:canon_type" do
      content_type :json
      Service.new(Bible::Book.get_list(params)).display
    end

    get "/api/full_book/:book" do
      content_type :json
      Service.new(Bible::Versions.load('asvd').get_by_reference(params[:book])).display
    end

    get "/api/book_chapter/:book/:chapter" do
      content_type :json
      Service.new(Bible::Versions.load('asvd').get_by_reference(params[:book], params[:chapter])).display
    end

    get "/api/ref/:book/:chapter/:numbers" do
      content_type :json
      Service.new(Bible::Versions.load('asvd').get_by_reference(params[:book], params[:chapter], params[:numbers])).display
    end

    get "/api/search/:context/:keyword" do
      content_type :json
      Service.new(Bible::Versions.load('asvd').search("#{params[:context]}:#{URI.unescape(params[:keyword])}")).display
    end
  end
end
