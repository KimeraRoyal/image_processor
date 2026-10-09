class ImageProcessor::ImageFormat
    def initialize(file_type, width, quality = 75)
      @file_type = file_type
      @width = width

      @quality = quality
    end

    attr_reader :file_type
    attr_reader :width
    
    attr_reader :quality
end