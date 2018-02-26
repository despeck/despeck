# frozen_string_literal: true

module Despeck
  class ColourChecker
    attr_reader :image, :threshold

    def initialize(image:, threshold: 30)
      @image = image
      @threshold = threshold
    end

    def black_and_white?
      black_and_white_pixels.count == histogram.count
      # TODO: Check if anything else but BW is present on the image
    end

    def primary_colours
      histogram - black_and_white_pixels
      # TODO: Detect watermark colour
    end

    private

    def black_and_white_pixels
      @black_and_white_pixels ||=
        histogram.select { |pxl| black_or_white?(pxl) }
    end

    def histogram
      hist = image.hist_find_ndim
      Vips::Image
        .new_from_buffer(hist.jpegsave_buffer(Q: 99), '')
        .to_a
        .flatten(1)
    end

    def black_or_white?(rgb_pixel)
      average = rgb_pixel.reduce(:+) / rgb_pixel.count
      min = average - threshold
      max = average + threshold
      rgb_pixel.all? { |ptr| min <= ptr && ptr <= max }
    end

    def bluish?(rgb_pixel)
      
    end
  end
end
