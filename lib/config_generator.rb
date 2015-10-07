require "yaml"
class ConfigGenerator
  attr_reader :book, :output_file

  def initialize(excel_file, output_file)
    @book = SpreadsheetParser.open(excel_file)
    @output_file = output_file
  end

  def generate
    config = {
      "index" => "",
      "url" => "",
      "type" => "",
      "bulk_size" => 100,
      "columns" => @book.columns.deep_stringify_keys
    }
    File.open(output_file, "w") do |file|
      file.write config.to_yaml
    end
  end
end
