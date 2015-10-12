require "roo"
class SpreadsheetParser
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def self.open(filename)
    new(filename)
  end

  def xls
    @xls ||= load_xls
  end

  def columns
    @columns ||= parse_columns
  end

  def rows
    @rows ||= parse
  end

  def each_row
    xls.each_row_streaming(offset: 1, pad_cells: true) do |row|
      yield row.map(&:value)
    end
  end

  def parse
    @rows = []

    xls.each_row_streaming(offset: 1, pad_cells: true) do |row|
      @rows << row.map(&:value)
    end
    @rows
  end

  private

  def load_xls
    xls = Roo::Excelx.new(filename)
    xls
  end

  def parse_columns
    column_names = {}
    columns = nil

    xls.each_row_streaming(max_rows: 2, pad_cells: true) do |row|
      if columns
        row.each_with_index do |cell, i|
          column_names[columns[i]] = cell.value.class.to_s.downcase
        end
      else
        columns = row.map(&:value)
      end
    end
    column_names
  end
end
