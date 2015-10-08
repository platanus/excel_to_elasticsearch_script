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
    @config.fetch("bulk_size", 1000)
  end

  def index
    @config["index"]
  end

  def type
    @config["type"]
  end

  def columns
    @config["columns"]
  end

  def columns_with_mappings
    @columns_with_mappings ||= @config["columns"]
      .reject { |_col, config| config["index"].nil? }
  end

  def calculated_columns
    @calculated_columns ||= @config["columns"]
      .select { |_col, config| config["calculated"] == true }
  end
end
