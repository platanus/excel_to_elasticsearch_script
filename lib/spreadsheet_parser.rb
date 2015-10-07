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

  def parse
    @rows = []

    xls.each_row_streaming(offset: 1) do |row|
      @rows << row.map(&:value)
    end
    @rows
  end

  private

  def load_xls
    xls = Roo::Spreadsheet.open(filename, extension: :xlsx)
    xls.default_sheet = xls.sheets.first
    xls
  end

  def parse_columns
    column_names = {}

    loop do
      column_name = xls.cell(1, column_names.size + 1)
      break if column_name.nil?

      column_data = xls.cell(2, column_names.size + 1)

      col_info = {}
      col_info[:type] = column_data.class.to_s.downcase

      column_names[column_name] = col_info
    end
    column_names
  end
end
