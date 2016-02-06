# This is a child of ruby StandardError
# For customizing errors for absent books
# When an attempt is made to fetch details
# due to a typo, wrong identifier or missing
# data from the database
class InvalidBookError < StandardError
  def initialize (book)
    @book = book
  end

  def message
    "The Bible does not contain this book: #{@book}"
  end
end
