class Record
  attr_reader :row, :book
  def initialize(row, book)
    @row = row
    @book = book
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
    index = book.columns.keys.index(name)
    raise "Column not found '#{name}'" if index.nil?
    row[index]
  end
end
