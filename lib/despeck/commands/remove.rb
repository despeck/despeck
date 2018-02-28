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

      option ['--no-contrast'],
             'no_contrast',
             'Do not apply contrast to output image',
             flag: true

      option ['--no-improve-black'],
             'no_improve_black',
             'Do not replace grayish pixels with true black',
             flag: true

      option ['-c', '--color'],
             'COLOR',
             'Watermark primary HEX colour (example: FEFE7E)',
             required: false

      parameter 'input_file', 'Input file - either PDF or image',
                attribute_name: :input_file
      parameter 'output_file', 'Output file (same format as input)',
                attribute_name: :output_file

      def execute
        wr = WatermarkRemover.new(
              no_contrast:      no_contrast,
              no_improve_black: no_improve_black,
              watermark_color:  color
            )
        wr.remove_watermark(input_file, output_file)
      end
    end
  end
end
