class ElasticConfig
  def initialize(config_file)
    File.open(config_file) do |file|
      @config = YAML.load(file)
    end
  end

  def url
    @config["url"]
  end

  def bulk_size
    @config["bulk_size"]
  end

  def index
    @config["index"]
  end

  def type
    @config["type"]
  end

  def columns_with_mappings
    @columns_with_mappings ||= @config["columns"]
      .reject { |_col, config| config["index"].nil? }
  end
end
