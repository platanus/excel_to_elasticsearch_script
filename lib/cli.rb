require "thor"
class CLI < Thor
  option :verbose, type: :boolean, aliases: :v, default: false
  option :regenerate, type: :boolean, aliases: :r, default: false
  option :limit, type: :numeric, aliases: :l, default: nil
  option :skip, type: :numeric, aliases: :s, default: nil
  desc "upload excel_file config_file", "Sube un archivo a elastic search"
  def upload(excel_file, config_file)
    ElasticUploader.new(excel_file, config_file, options).run
  end

  desc "generate_config excel_file output_file", "Genera un archivo de configuracion para un XLS"
  def generate_config(excel_file, output_file)
    ConfigGenerator.new(excel_file, output_file).generate
  end

  option :limit, type: :numeric, aliases: :l, default: 100_000
  desc "big_upload excel_file config_file", "Sube un archivo a elastic search"
  def big_upload(excel_file, config_file)
    BatchElasticUploader.new(excel_file, config_file, options).run
  end
end
