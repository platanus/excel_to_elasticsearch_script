require "roo"
class SpreadsheetParser < Struct.new(:filename)

  def self.open(filename)
    new(filename).parse
  end

  def xls
    @xls ||= load_xls
  end

  def columns
    @columns ||= parse_columns
  end

  def parse
    rows = []
    row_index = 2

    loop do
      row = []

      columns.each_with_index do |column, index|
        data = xls.cell(row_index, index + 1)
        row << data
      end

      break if row.compact.empty?

      rows << row
      row_index += 1
    end

    self
  end

  private

  def load_xls
    xls = Roo::Spreadsheet.open(filename, extension: :xlsx)
    xls.default_sheet = xls.sheets.first
    xls
  end

  def parse_columns
    column_names = []

    loop do
      column_name = xls.cell(1, column_names.size + 1)
      break if column_name.nil?

      column_names << column_name
    end
    column_names
  end

end
