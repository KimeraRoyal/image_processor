class ImageProcessor::ImageFormat
    def initialize(file_type, width, quality = 75)
      @file_type = file_type
      @width = width
    end

    attr_reader :file_type
    attr_reader :width
end