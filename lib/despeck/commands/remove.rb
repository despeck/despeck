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

      parameter 'input file', 'Input file - either PDF or image',
                attribute_name: :input_file
      parameter 'output file', 'Output file (same format as input)',
                attribute_name: :output_file
      parameter 'color', 'Color to be removed (example: #e86751)',
                attribute_name: :color

      def execute
        # binding.pry
        image = Vips::Image.new_from_file(input_file)

        # Preprocess: remove white noise from scanning
        # distance = Vips::Image.sum(((image - [255, 255, 255]) ** 2).bandsplit) ** 0.5
        # swap pixels more than 50 away for white
        # image = (distance < sensitivity).ifthenelse([255, 255, 255], image)

        # the color we search for as a CIELAB coordinate
        # match = [54.64, 61.16, 51.76]
        # image = image.colourspace('b-w')
        # match = hex_to_rgb(color)
        # distance = image.dE76(image.new_from_image(match))
        # image = (distance > sensitivity).ifthenelse([255, 255, 255], image)

        # # binding.pry
        # # image.more_const1(220)
        image = grayscale_algorithm(image)
        image = image.colourspace('b-w')
        # image = increase_contrast(image)
        image = improve_black(image)
        image.write_to_file(output_file)#'output/01.jpg')
      end

      private

      def grayscale_algorithm(image)
        # TODO: Write a function to add adjust those params from color provided
        #       or from `sensitivity` option
        image.recomb([1.2, 0.03, 0.03])
      end

      def increase_contrast(bw_image)
        # Works pretty bad
        # bw_image.recomb([0.95])
        # bw_image.linear([0.9], [0])
        # bw_image.linear([1.2], [50])
        bw_image.colourspace('lch') * [1, 100, 100] + [0, 0, 500]
      end

      def improve_black(image)
        match = [0, 0, 0]
        distance = image.dE76(image.new_from_image(match))
        (distance < 80).ifthenelse([0, 0, 0], image)
      end

      def hex_to_rgb(hex)
        hex = hex.gsub(/^#/, '')
        hex.chars.each_slice(2).map { |p| Integer("0x#{p.join}") }
      end

      def sigmoid(a, b)
        lut = Vips::Image.identity(ushort: false)
        max = lut.max
        lut = lut.divide([max])
        x = 1.0 / (1.0 + Math.exp(a * b))
        y = 1.0 / (1.0 + Math.exp((a - 10) * b)) - x
        z = lut.multiply([-1]).add([a]).multiply([b]).exp.add([1])
        result = (z ** -1).subtract([x]).divide([y])
        result = result.multiply([max])
        result = result.cast(:uchar)
      end
    end
  end
end
