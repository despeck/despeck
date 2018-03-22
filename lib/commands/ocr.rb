# frozen_string_literal: true

module Despeck
  module Commands
    # Subcommand that removes watermarks from images & PDFs
    class Ocr < Clamp::Command
      parameter 'input_file', 'Input file - either PDF or image',
                attribute_name: :input_file
      option ['-l', '--lang'],
             'LANGUAGE',
             'One of supported Tesseract languages (`eng` by default)',
             default: :eng

      def execute
        puts Despeck::Ocr.new(input_file).text(lang: lang)
      end
    end
  end
end
