class ElasticUploader
  attr_reader :filename, :config, :regenerate, :verbose

  def initialize(filename, config_file, regenerate, verbose)
    @bulk = []
    @filename = filename
    @regenerate = regenerate
    @config = ElasticConfig.new(config_file)
    @verbose = verbose
  end

  def client
    @client ||= Elasticsearch::Client.new host: config.url, log: verbose
  end

  def run
    @book = SpreadsheetParser.open(filename)

    prepare_index

    @book.rows.each { |row| queue_insertion row }
    send_to_es if @bulk.length > 0
  end

  def prepare_index
    if client.indices.exists? index: config.index
      if regenerate
        drop_index
        create_index
      end
    else
      create_index
    end
  end

  def row_to_bulk(row)
    data = {}
    @book.columns.keys.each_with_index { |col, i| data[col] = row[i] }
    config.calculated_columns.each do |col, opts|
      data[col] = Record.new(row, config).instance_eval(opts["formula"])
    end
    data
  end

  def drop_index
    client.indices.delete index: config.index
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
