# frozen_string_literal: true

module Despeck
  # Checks if image is black and white or colourized
  class ColourChecker
    attr_reader :image, :percent_threshold, :de_threshold

    PERCENT_THRESHOLD = 99
    DE_THRESHOLD      = 20

    def initialize(image:, **options)
      @image = image
      @image = @image.resize(options.fetch(:resize, 1.0))
      @percent_threshold = options.fetch(:percent, PERCENT_THRESHOLD)
      @de_threshold      = options.fetch(:de,      DE_THRESHOLD)
    end

    def black_and_white?
      euclidean_distance =
        image.colourspace('lch')[1].cast('uchar').percent(percent_threshold)
      euclidean_distance <= de_threshold
    end
  end
end
