require "thor"
class CLI < Thor
  desc "upload filename url index type", "Sube un archivo a elastic search"
  def upload(filename, url, index, type)
    ElasticUploader.new(filename, url, index, type).run
  end
end
