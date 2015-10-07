require "thor"
class CLI < Thor
  desc "upload filename url index type", "Sube un archivo a elastic search"
  def upload(filename, url, index, type)
    ElasticUploader.new(filename, url, index, type).run
  end

  desc "generate_config excel_file output_file", "Genera un archivo de configuracion para un XLS"
  def generate_config(excel_file, output_file)
    ConfigGenerator.new(excel_file, output_file).generate
  end
end
