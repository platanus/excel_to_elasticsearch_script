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

  def columns_with_mappings
    columns.reject{|col, config| config[:index].nil? }
  end

  def rows
    @rows
  end

  def parse
    @rows = []

    xls.each_row_streaming(offset: 2) do |row|
      @rows << row.map{|col| col.value}
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
    column_names = {}

    loop do
      column_name = xls.cell(1, column_names.size + 1)
      break if column_name.nil?

      column_type = xls.cell(2, column_names.size + 1)
      column_data = xls.cell(3, column_names.size + 1)

      col_info = {}
      col_info[:type] = column_data.class.to_s.downcase
      col_info[:index] = "not_analyzed" unless column_type.nil?

      column_names[column_name] = col_info
    end
    column_names
  end

end
