# frozen_string_literal: true

module Despeck
  class ColourChecker
    attr_reader :image, :percent_threshold, :de_threshold

    PERCENT_THRESHOLD = 99
    DE_THRESHOLD      = 20

    def initialize(image:, percent: PERCENT_THRESHOLD, de: DE_THRESHOLD)
      @image = image
      # TODO: Resize image to make it work faster?
      @percent_threshold = percent
      @de_threshold      = de
    end

    def black_and_white?
      dE = image.colourspace('lch')[1].cast('uchar').percent(percent_threshold)
      dE <= de_threshold
    end
  end
end
