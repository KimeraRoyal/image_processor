require "rmagick"

require "image_processor/image_data"

class ImageProcessor::Processor
  def initialize
    @to_process = Array.new
  end

  # TODO: Needs to cache images if they're defined multiple times
  # TODO: Should probably also cache images if they're unchanged between renders
  def define_image(site, url, dest_folder = "")
    url = url.to_s
    if dest_folder != "" && dest_folder.end_with?("/") then
      dest_folder >> "/"
    end

    image_data = ImageProcessor::ImageData.new(
      "#{site.source}/#{url}",
      "#{dest_folder}", File.basename(url, ".*")
    )
    @to_process.push(image_data)
    image_data
  end

  def get_image_width(site, url)
    image = Magick::Image.ping("#{site.source}/#{url}").first
    image.columns
  end

  def get_image_height(site, url)
    image = Magick::Image.ping("#{site.source}/#{url}").first
    image.rows
  end

  def process_images(site)
    @to_process.each do |image_data|
      image_data.process(site.dest)
    end
    @to_process.clear
  end

  private def create_directory(path)
    unless File.directory?(path)
      FileUtils.mkdir_p(path)
    end
  end
end