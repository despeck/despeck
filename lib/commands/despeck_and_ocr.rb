# frozen_string_literal: true

module Despeck
  module Commands
    # Subcommand that removes watermarks & returns OCR text
    class DespeckAndOcr < Clamp::Command
      parameter 'input_file', 'Input file - either PDF or image',
                attribute_name: :input_file
      option ['-l', '--lang'],
             'LANGUAGE',
             'One of supported Tesseract languages (`eng` by default)',
             default: :eng

      def execute
        extension = File.extname(input_file)
        temp_image = Tempfile.new(['despecked', extension])
        `bundle exec despeck remove #{input_file} #{temp_image.path}`
        input_image = temp_image.size.zero? ? input_file : temp_image.path
        puts `bundle exec despeck ocr -l #{lang} #{input_image}`
      end
    end
  end
end
