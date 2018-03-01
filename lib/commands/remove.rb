# frozen_string_literal: true

module Despeck
  module Commands
    class Remove < Clamp::Command
      option ['-s', '--sensitivity'],
             'SENSITIVITY',
             'Sensitivity of algorithm, from 0 to 100',
             default: 100 do |s|
               Integer(s)
             end

      option ['--add-contrast'],
             :flag,
             'Improve contrast of the output image'

      option ['--add-black'],
             :flag,
             'Replace grayish pixels with true black'

      option ['--debug'], :flag, 'Show debug information'

      option ['-c', '--color'],
             'COLOR',
             'Watermark primary HEX colour (example: FEFE7E)',
             required: false

      parameter 'input_file', 'Input file - either PDF or image',
                attribute_name: :input_file
      parameter 'output_file', 'Output file (same format as input)',
                attribute_name: :output_file

      def execute
        Despeck.apply_logger_level(debug?)

        wr = WatermarkRemover.new(
              add_contrast:    add_contrast?,
              add_black:       add_black?,
              sensitivity:     sensitivity,
              watermark_color: color
            )
        input_image = Vips::Image.new_from_file(input_file)

        output_image = wr.remove_watermark(input_image)
        output_image.write_to_file(output_file) if output_image
      end
    end
  end
end
