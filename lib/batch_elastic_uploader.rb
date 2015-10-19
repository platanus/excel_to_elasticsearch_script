class BatchElasticUploader
  attr_reader :filename, :config_file, :limit
  CMD = "ruby add_to_index.rb upload"

  def initialize(filename, config_file, options)
    @count = 0
    @filename = filename
    @config_file = config_file
    @limit = options[:limit]
  end

  def run
    page = 0
    processed = true
    while processed
      from = 1 + (page * limit)
      opts = "-s #{from} -l #{limit}"
      puts "Procesando rango #{opts}"
      processed = system "#{CMD} #{filename} #{config_file} #{opts}"
      page += 1
    end
  end
end
