class ElasticUploader
  attr_reader :filename, :url, :index, :type

  def initialize(filename, url, index, type)
    @filename = filename
    @url = url
    @index = index
    @type = type
  end

  def run
    @book = SpreadsheetParser.open(filename)
    @book.parse

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

    @bulk = []
    @book.rows.each { |row| add_to_index row, index, type }
    client.bulk body: @bulk
  end

  def row_to_bulk(row)
    data = {}
    @book.columns.keys.each_with_index { |col, i| data[col] = row[i] }
    data
  end

  def add_to_index(row, index, type)
    @bulk << { index: { _index: index, _type: type } }
    @bulk << row_to_bulk(row)
  end
end
