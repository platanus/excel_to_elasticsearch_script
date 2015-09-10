require "roo"

filename = ARGV[0]
url = ARGV[1]
index = ARGV[2]

if filename.nil? || url.nil? || index.nil?
  raise "add_to_index.rb data.xls host_url index"
end

xls = Roo::Spreadsheet.open(filename, extension: :xlsx)

xls.default_sheet = xls.sheets.first

column_names = []

loop do
  column_name = xls.cell(1, column_names.size + 1)
  break if column_name.nil?

  column_names << column_name
end

p column_names

rows = []
row_index = 2

loop do
  row = []

  column_names.each_with_index do |column, index|
    data = xls.cell(row_index, index + 1)
    row << data
  end

  break if row.compact.empty?

  rows << row
  row_index += 1
end

p rows
