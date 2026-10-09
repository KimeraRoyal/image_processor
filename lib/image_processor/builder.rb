require "image_processor/image_processor"

class ImageProcessor::Builder < Bridgetown::Builder
  def build
    @processor = ImageProcessor::Processor.new

    liquid_tag "define_image", :define_image
    helper :define_image, :define_image

    hook :site, :post_write do |site|
      @processor.process_images(site)
    end
  end

  def define_image(url, dest_folder = "")
    @processor.define_image(@site, url, dest_folder)
  end
end
