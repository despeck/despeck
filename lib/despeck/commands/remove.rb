# frozen_string_literal: true

# To read: https://github.com/jcupitt/libvips/issues/59

module Despeck
  module Commands
    class Remove < Clamp::Command
      option ['-s', '--sensitivity'],
             'SENSITIVITY',
             'Sensitivity of algorithm, from 0 to 100',
             default: 55 do |s|
               Integer(s)
             end

      option ['--apply-contrast'],
             'apply_contrast',
             'Increase contrast of output image?',
             flag: true

      option ['--improve-black'],
             'improve_black',
             'Replace all grayish pixels to true black?',
             flag: true

      option ['-c', '--color'],
             'COLOR',
             'Watermark primary HEX colour (example: FEFE7E)',
             required: true

      parameter 'input_file', 'Input file - either PDF or image',
                attribute_name: :input_file
      parameter 'output_file', 'Output file (same format as input)',
                attribute_name: :output_file

      def execute
        image = Vips::Image.new_from_file(input_file)
        return if ColourChecker.new(image: image).black_and_white?

        image = grayscale_algorithm(image)
        # image = image.colourspace('b-w')
        image = increase_contrast(image) if apply_contrast
        image = apply_black_improvement(image) if improve_black
      ensure
        image.write_to_file(output_file)
      end

      private

      def grayscale_algorithm(image)
        image.recomb(greyscale_params)
      end

      def greyscale_params
        r, g, b = hex_to_rgb(color)
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
end
