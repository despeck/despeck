# frozen_string_literal: true

module Despeck
  module Commands
    # Subcommand that removes watermarks from images & PDFs
    class Remove < Clamp::Command
      option(['-s', '--sensitivity'],
             'SENSITIVITY',
             'Sensitivity of algorithm, defaults to 100',
             default: 100) do |s|
               Integer(s)
             end

      option ['--add-contrast'],
             :flag,
             'Improve contrast of the output image',
             default: false

      option ['--add-black'],
             :flag,
             'Replace grayish pixels with true black',
             default: false

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

        if input_file.end_with?('.pdf')
          images =
            PdfTools.pdf_to_images(input_file).map do |image|
              remove_watermark_from_image(image, nil)
            end
          # binding.pry
          PdfTools.images_to_pdf(images, output_file)
        else
          remove_watermark_from_image(input_file, output_file)
        end
      end

      private

      def remove_watermark_from_image(input, output)
        wr =
          WatermarkRemover.new(
            add_contrast:    add_contrast?,
            add_black:       add_black?,
            sensitivity:     sensitivity,
            watermark_color: color
          )

        input_image =
          if input.is_a?(String)
            Vips::Image.new_from_file(input)
          else
            input
          end

        output_image = wr.remove_watermark(input_image)
        return output_image unless output

        output_image&.write_to_file(output)
      end
    end
  end
end
