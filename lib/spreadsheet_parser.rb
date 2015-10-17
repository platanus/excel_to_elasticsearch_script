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

  def each_row(args)
    rerun = true
    offset = args[:skip] || 1
    limit = args[:limit]
    i = offset
    records_processed = 1
    while rerun
      rerun = false
      load_xls
      xls.each_row_streaming(offset: offset, pad_cells: true) do |row|
        print "\r"
        print "reading row #{i}"
        r = row.map do |cell|
          cell.value rescue ""
        end
        yield r
        i += 1
        records_processed += 1
        break if limit && records_processed > limit
        if (i % 100000) == 0
          puts "Reloading XLS"
          offset = i
          rerun = true
          break
        end
      end
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
    if @xls
      @xls.close
      @xls = nil
      GC.start
    end
    @xls = Roo::Excelx.new(filename)
  end

  def parse_columns
    column_names = {}
    columns = nil

    xls.each_row_streaming(max_rows: 2, pad_cells: true) do |row|
      if columns
        row.each_with_index do |cell, i|
          column_names[columns[i]] = cell.value.class.to_s.downcase rescue 'string'
        end
      else
        columns = row.map(&:value)
      end
    end
    column_names
  end
end
