# frozen_string_literal: true

module Despeck
  # Takes an image and removes watermark
  class WatermarkRemover
    attr_reader :add_contrast, :black_const,
                :watermark_color, :resize, :sensitivity, :accurate

    def initialize(options = {})
      apply_options!(options)

      Despeck.logger.debug "Sensitivity: #{sensitivity}"
      Despeck.logger.debug "Contrast improvement: #{add_contrast}"
      Despeck.logger.debug "Black level improvement: #{black_const}"
    end

    def remove_watermark(image)
      output_image = nil
      time =
        Benchmark.realtime do
          output_image =
            if accurate
              __remove_watermark_only__(image)
            else
              __remove_watermark__(image)
            end
        end
      Despeck.logger.debug "Time taken: #{time} seconds"

      output_image
    end

    private

    def apply_options!(options)
      @add_contrast    = options.fetch(:add_contrast, true)
      @black_const     = options.fetch(:black_const, -110)
      @watermark_color = options.fetch(:watermark_color, nil)
      @resize          = options.fetch(:resize, 0.1)
      @sensitivity     = options.fetch(:sensitivity, 160)
      @accurate        = options.fetch(:accurate, false)
    end

    # keep the rest of the image untouched
    def __remove_watermark_only__(image)
      watermark, no_watermark, mask =
        WatermarkMask.new(image).find_masks!
      output_image = __remove_watermark__(watermark)
      return unless output_image

      no_watermark = no_watermark.colourspace('b-w').bandjoin(mask.invert)

      output_image = output_image.colourspace('srgb') if output_image.bands < 3
      output_image = output_image.bandjoin(mask) if output_image.bands == 3
      output_image.composite(no_watermark, 'over')
    end

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
      image.recomb([rgb_params])
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
