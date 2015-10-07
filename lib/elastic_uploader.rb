class ElasticUploader
  attr_reader :filename, :config

  def initialize(filename, config_file)
    @bulk = []
    @filename = filename
    @config = ElasticConfig.new(config_file)
  end

  def client
    @client ||= Elasticsearch::Client.new host: config.url, log: true
  end

  def create_index
    body = {
      mappings: {
        config.type => {
          properties: config.columns_with_mappings
        }
      }
    }
    client.indices.create index: config.index, body: body
  end

  def run
    @book = SpreadsheetParser.open(filename)

    create_index unless client.indices.exists? index: config.index

    @book.rows.each { |row| queue_insertion row }
    send_to_es if @bulk.length > 0
  end

  def row_to_bulk(row)
    data = {}
    @book.columns.keys.each_with_index { |col, i| data[col] = row[i] }
    data
  end

  def queue_insertion(row)
    @bulk << { index: { _index: config.index, _type: config.type } }
    @bulk << row_to_bulk(row)
    send_to_es if (@bulk.length / 2) > config.bulk_size
  end

  def send_to_es
    if @bulk.length > 0
      puts "Sending #{@bulk.length / 2} records to ES"
      client.bulk body: @bulk
      @bulk = []
    end
  end
end
