require "image_processor/file_util"

require "image_processor/image_format" 

class ImageProcessor::ImageData
  def initialize(source_path, dest_folder, dest_filename)
    @source_path = source_path
    @dest_folder = dest_folder
    @dest_filename = dest_filename

    @source_format = File.extname(source_path)[1..-1]
    @formats = Array.new
    @gif_optimizations = Array.new
  end

  def add_format(file_type, width, quality = 75)
    @formats.push(ImageProcessor::ImageFormat.new(file_type, width, quality))
    self
  end

  def apply_gif_optimization(optimization)
    @gif_optimizations.push(optimization)
    self
  end

  def apply_default_gif_optimizations()
    @gif_optimizations.push(Magick::CoalesceLayer)
    @gif_optimizations.push(Magick::OptimizeLayer)
    @gif_optimizations.push(Magick::RemoveDupsLayer)
    @gif_optimizations.push(Magick::RemoveZeroLayer)
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
    Bridgetown.logger.info("Processing \"#{@source_path}\" (#{get_file_size(@source_path)})")
    source_list = Magick::Image.read(@source_path)
    if(source_list.length == 1)
      process_single(source_list.first, output_path)
    elsif(source_list.length > 1)
      process_frames(source_list, output_path)
    end
  end

  private def process_single(source, output_path)
    source.strip!()
    if formats.length > 0 then
      formats.each do |format|
        process_single_format(source, output_path, format)
      end
    else
      process_single_format(source, output_path, nil)
    end
  end

  private def process_single_format(source, output_path, format)
    result = process_format(source, format)
    dest_path = "#{output_path}/#{@dest_folder}/#{get_format_filename(format)}"
    ImageProcessor::FileUtil.write(result, dest_path)
    Bridgetown.logger.info("Written to file \"#{dest_path}\" (#{get_file_size(dest_path)})")
    Bridgetown.logger.info("#{get_file_size(@source_path)} -> #{get_file_size(dest_path)}")
  end

  private def process_frames(source_list, output_path)
    if formats.length > 0 then
      formats.each do |format|
        process_frames_format(source_list, output_path, format)
      end
    else
      process_frames_format(source_list, output_path, nil)
    end
  end

  private def process_frames_format(source_list, output_path, format)
    result = Magick::ImageList.new
    source_list.each do |source|
      result.push(process_format(source, format))
    end
    @gif_optimizations.each do |optimization|
      result = result.optimize_layers(optimization)
    end
    result = result.deconstruct
    dest_path = "#{output_path}/#{@dest_folder}/#{get_format_filename(format)}"
    ImageProcessor::FileUtil.write(result, dest_path)
    Bridgetown.logger.info("Written to file \"#{dest_path}\" (#{get_file_size(dest_path)})")
    Bridgetown.logger.info("#{get_file_size(@source_path)} -> #{get_file_size(dest_path)}")
  end

  private def process_format(source, format)
    result = source
    unless format == nil then
      unless source.columns == format.width then
        scale_factor = source.columns.to_f / format.width
        result = source.resize(format.width, source.rows / scale_factor)
      end
    end
    result
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

  private def get_file_size(path)
    "#{'%.2f' % ImageProcessor::FileUtil.size_in_kb(path)}KB"
  end

  attr_reader :source_path
  attr_reader :dest_folder
  attr_reader :dest_filename

  attr_reader :formats
end