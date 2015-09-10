require_relative "lib/spreadsheet_parser"

filename = ARGV[0]
url = ARGV[1]
index = ARGV[2]

if filename.nil? || url.nil? || index.nil?
  raise "add_to_index.rb data.xls host_url index"
end

book = SpreadsheetParser.open(filename)
p book.columns
