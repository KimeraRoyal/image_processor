module ImageProcessor::FileUtil
  def write(source, dest_path)
    create_directory(File.dirname(dest_path))
    FileUtils.touch(dest_path)
    source.write(dest_path)
  end
  module_function :write

  def create_directory(path)
    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end
  end
  module_function :create_directory

  def size_in_kb(path)
    File.size(path).to_f / 2**10
  end
  module_function :size_in_kb

  def size_in_mb(path)
    File.size(path).to_f / 2**20
  end
  module_function :size_in_mb
end