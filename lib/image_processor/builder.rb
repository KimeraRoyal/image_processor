require "image_processor/image_processor"

class ImageProcessor::Builder < Bridgetown::Builder
  def build
    @processor = ImageProcessor::Processor.new

    liquid_tag "define_image", :define_image
    helper :define_image, :define_image

    liquid_tag "get_image_width", :get_image_width
    liquid_tag "get_image_height", :get_image_height
    helper :get_image_width, :get_image_width
    helper :get_image_height, :get_image_height

    hook :site, :post_write do |site|
      @processor.process_images(site)
    end
  end

  def define_image(url, dest_folder = "")
    @processor.define_image(@site, url, dest_folder)
  end

  def get_image_width(url)
    @processor.get_image_width(@site, url)
  end

  def get_image_height(url)
    @processor.get_image_height(@site, url)
  end
end
