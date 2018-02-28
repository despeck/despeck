# frozen_string_literal: true

module Despeck
  class WatermarkRemover
    attr_reader :no_contrast, :no_improve_black, :watermark_color

    def initialize(no_contrast: false,
                   no_improve_black: false,
                   watermark_color: nil)
      @no_contrast      = no_contrast
      @no_improve_black = no_improve_black
      @watermark_color  = watermark_color
    end

    def remove_watermark(input_file, output_file)
      image = Vips::Image.new_from_file(input_file)
      return if ColourChecker.new(image: image).black_and_white?

      wm_color = watermark_color || detect_watermark_color(image)
      image = grayscale_algorithm(image, wm_color)
      image = increase_contrast(image)       unless no_contrast
      image = apply_black_improvement(image) unless no_improve_black
    ensure
      image.write_to_file(output_file)
    end

    private

    def detect_watermark_color(image)
      Despeck::DominantColor.dominant_color(image)
    end

    def grayscale_algorithm(image, pr_color)
      image.recomb(greyscale_params(pr_color))
    end

    def greyscale_params(pr_color)
      r, g, b = hex_to_rgb(pr_color)
      case [r, g, b].max
      when r
        [1.2, 0.03, 0.03]
      when g
        [0.03, 1.4, 0.03]
      when b
        [0.03, 0.03, 1.4]
      end
    end

    def increase_contrast(bw_image)
      bw_image.colourspace('lch') * [1, 100, 100] + [0, 0, 500]
    end

    def apply_black_improvement(image)
      match = [0, 0, 0]
      distance = image.dE76(image.new_from_image(match))
      (distance < 80).ifthenelse([0, 0, 0], image)
    end

    def hex_to_rgb(hex)
      hex = hex.gsub(/^#/, '')
      hex.chars.each_slice(2).map { |p| Integer("0x#{p.join}") }
    end
  end
end
