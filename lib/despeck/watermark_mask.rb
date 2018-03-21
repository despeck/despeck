# frozen_string_literal: true

module Despeck
  # Creates B&W mask for the watermark
  class WatermarkMask
    attr_reader :image,
                :watermark,
                :no_watermark,
                :sensitivity,
                :mask

    def initialize(image, sensitivity: 20)
      @image       = image
      @sensitivity = sensitivity
    end

    def find_masks!
      @mask = adjusted_chroma_mask(image)

      @watermark    = (image + @mask.invert)
      @no_watermark = (image + @mask)

      [watermark, no_watermark, mask]
    end

    private

    def adjusted_chroma_mask(image)
      smaller_image = image.resize(0.2)
      closing(chroma_mask(smaller_image))
        .dilate(dilate_mask)
        .resize(5)
    end

    def chroma_mask(img)
      img = img.colourspace 'lch'
      (img[1] > sensitivity)
    end

    def dilate_mask
      @dilate_mask ||=
        Vips::Image.new_from_array Array.new(3, Array.new(3, 255))
    end

    def closing(img)
      img.dilate(dilate_mask).erode(dilate_mask)
    end
  end
end
