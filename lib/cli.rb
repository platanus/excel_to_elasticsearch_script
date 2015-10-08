require "thor"
class CLI < Thor
  option :verbose, type: :boolean, aliases: :v, default: false
  option :regenerate, type: :boolean, aliases: :r, default: false
  desc "upload excel_file config_file", "Sube un archivo a elastic search"
  def upload(excel_file, config_file)
    ElasticUploader.new(excel_file, config_file, options[:regenerate], options[:verbose]).run
  end

  desc "generate_config excel_file output_file", "Genera un archivo de configuracion para un XLS"
  def generate_config(excel_file, output_file)
    ConfigGenerator.new(excel_file, output_file).generate
  end
end
