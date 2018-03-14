# frozen_string_literal: true

module Despeck
  # Takes an image and removes watermark
  class WatermarkRemover
    attr_reader :add_contrast, :black_const,
                :watermark_color, :resize, :sensitivity

    def initialize(options = {})
      @add_contrast    = options.fetch(:add_contrast, true)
      @black_const     = options.fetch(:black_const, -110)
      @watermark_color = options.fetch(:watermark_color, nil)
      @resize          = options.fetch(:resize, 0.1)
      @sensitivity     = options.fetch(:sensitivity, 160)

      Despeck.logger.debug "Sensitivity: #{sensitivity}"
      Despeck.logger.debug "Contrast improvement: #{add_contrast}"
      Despeck.logger.debug "Black level improvement: #{black_const}"
    end

    def remove_watermark(image)
      output_image = nil
      time =
        Benchmark.realtime do
          output_image = __remove_watermark__(image)
        end
      Despeck.logger.debug "Time taken: #{time} seconds"

      output_image
    end

    private

    def __remove_watermark__(image)
      return if no_watermark?(image)

      wm_color = watermark_color || detect_watermark_color(image)
      Despeck.logger.debug "Watermark colour channel detected: #{wm_color}"
      output_image = grayscale_algorithm(image, wm_color)
      output_image = increase_contrast(output_image) if add_contrast
      output_image = apply_black_improvement(output_image)
      output_image = apply_grey_to_black(output_image) if wm_color != 'FF0000'
      output_image
    end

    def no_watermark?(image)
      return false if watermark_color

      if ColourChecker.new(image: image, resize: resize).black_and_white?
        Despeck.logger.error "Can't find watermark, skipping."
        return true
      end

      false
    end

    def detect_watermark_color(image)
      Despeck::DominantColor.dominant_color(image)
      # Despeck::DominantColorV2.dominant_color(image)
    end

    def grayscale_algorithm(image, pr_color)
      rgb_params = greyscale_params(pr_color)
      rgb_params << 0 if image.bands == 4
      image.recomb(rgb_params)
    end

    def greyscale_params(pr_color)
      r, g, b = hex_to_rgb(pr_color)
      defaults =
        case [r, g, b].max
        when r
          [1.2, 0.03, 0.03]
        when g
          [0.03, 1.4, 0.03]
        when b
          [0.03, 0.03, 1.4]
        end

      apply_sentivity(defaults)
    end

    # rubocop:disable Metrics/AbcSize
    def apply_sentivity(rgb)
      max = rgb.max
      res = rgb.map do |value|
        if value == max
          value * (sensitivity.to_f / 100)
        else
          value / (sensitivity.to_f / 100)
        end
      end
      Despeck.logger.debug "Remove channel value: #{res.max}"
      Despeck.logger.debug "Untouched channels value: #{res.min}"

      res
    end
    # rubocop:enable Metrics/AbcSize

    def increase_contrast(bw_image)
      bw_image.colourspace('lch') * [1, 100, 100] + [0, 0, 500]
    end

    def apply_black_improvement(image)
      image.colourspace('b-w').linear(1, black_const)
    end

    def apply_grey_to_black(image)
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
