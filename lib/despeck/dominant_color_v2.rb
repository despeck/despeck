# frozen_string_literal: true

module Despeck
  # Finds average (?) 'colourful' colour
  module DominantColorV2
    class << self
      def dominant_color(image)
        image = image.resize(0.05)
        image_pixels = image.colourspace('srgb').to_a
        colors = []
        mask(image).to_a.each_with_index do |row, i|
          row.each_with_index do |pixel, j|
            next unless white_pixel?(pixel)

            colors << image_pixels[i][j]
          end
        end

        [average(colors, 0), average(colors, 1), average(colors, 2)]
      end

      private

      def mask(image, sens = 5)
        image = image.colourspace 'lch'
        (image[1] > sens)
      end

      def white_pixel?(pixel)
        pixel.all? { |c| c >= 245 }
      end

      def average(pixels, channel)
        total = pixels.map { |i| i[channel] }.reduce(:+).to_f
        puts "Average (#{channel}): #{total} / #{pixels.count}"
        (total / pixels.count.to_f).to_i
      end
    end
  end
end
