class Record
  attr_reader :row, :config
  def initialize(row, config)
    @row = row
    @config = config
  end

  def [](index_or_name)
    if index_or_name.is_a? String
      value_by_name(index_or_name)
    else
      row[index_or_name]
    end
  end

  private

  def value_by_name(name)
    index = config.columns.keys.index(name)
    raise "Column not found '#{name}'" if index.nil?
    row[index]
  end
end
