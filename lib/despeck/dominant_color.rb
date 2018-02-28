# frozen_string_literal: true

module Despeck
  module DominantColor
    class << self
      def dominant_color(image)
        color_pixels = non_black_colors(image)
        primary_color(color_pixels)
      end

      private

      def non_black_colors(image)
        pixels = image.resize(0.02).to_a
        pixels.flatten(1).select { |p| !black_and_white?(p) }
      end

      def primary_color(colors)
        red, green, blue = 0, 0, 0
        colors.each do |pixel|
          r, g, b = pixel
          case pixel.max
          when r
            red += 1
          when g
            green += 1
          when b
            blue += 1
          end
        end

        case [red, green, blue].max
        when red
          'FF0000'
        when green
          '00FF00'
        when blue
          '0000FF'
        end
      end

      def black_and_white?(pixel)
        average = pixel.reduce(:+) / pixel.count
        min = average - 30
        max = average + 30
        pixel.all? { |i| min <= i && i <= max }
      end
    end
  end
end
  