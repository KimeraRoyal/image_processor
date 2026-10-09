require "image_processor/image_format" 

class ImageProcessor::ImageData
  def initialize(source_path, dest_folder, dest_filename)
    @source_path = source_path
    @dest_folder = dest_folder
    @dest_filename = dest_filename

    @formats = Array.new
  end

  def add_format(file_type, width, quality = 75)
    @formats.push(ImageProcessor::ImageFormat.new(file_type, width, quality))
    self
  end

  def render(format_index = -1)
    format = nil
    unless format_index < 0 then
      format = formats[format_index]
    end
    filename = get_format_filename(format)
    "#{@dest_folder}/#{filename}"
  end

  def process(output_path)
    source = Magick::Image.read(@source_path).first
    source.strip!()
    if formats.length > 0 then
      formats.each do |format|
        process_format(output_path, source, format)
      end
    else
      process_format(output_path, source, nil)
    end
  end

  def process_format(output_path, source, format)
    result = source
    quality = 75

    unless format == nil then
      quality = format.quality
      unless source.columns == format.width then
        scale_factor = source.columns.to_f / format.width
        result = source.resize(format.width, source.rows / scale_factor)
      end
    end

    dest_path = "#{output_path}/#{@dest_folder}/#{get_format_filename(format)}"
    Bridgetown.logger.info(dest_path)
    create_directory("#{output_path}/#{@dest_folder}")
    FileUtils.touch(dest_path)

    result.write(dest_path) { |options|
      options.quality = quality
    }
  end

  private def get_format_filename(format)
    unless format then
      "#{@dest_filename}#{File.extname(@source_path)}"
    else
      "#{@dest_filename}-#{format.width}.#{format.file_type}"
    end
  end

  private def get_format_extension(format)
    unless format then
      File.extname(@source_path)
    else
      ".#{format.file_type}"
    end
  end

  private def create_directory(path)
    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end
  end

  attr_reader :source_path
  attr_reader :dest_folder
  attr_reader :dest_filename

  attr_reader :formats
end