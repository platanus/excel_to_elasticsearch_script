require_relative "lib/spreadsheet_parser"
require "elasticsearch"

filename = ARGV[0]
url = ARGV[1]
index = ARGV[2]
type = ARGV[3]

if filename.nil? || url.nil? || index.nil?
  raise "add_to_index.rb data.xls host_url index type"
end

@book = SpreadsheetParser.open(filename)

client = Elasticsearch::Client.new host: url, log: true

unless client.indices.exists? index: index
  body = {
    mappings: {
      type => {
        properties: @book.columns_with_mappings
      }
    }
  }
  client.indices.create index: index, body: body
end

def row_to_bulk(row)
  data = {}
  @book.columns.keys.each_with_index {|col, i| data[col] = row[i]}
  data
end

def add_to_index(row, index, type)
  @bulk << { index: { _index: index, _type: type } }
  @bulk << row_to_bulk(row)
end



@bulk = []
@book.rows.each {|row| add_to_index row, index, type }
client.bulk body: @bulk
