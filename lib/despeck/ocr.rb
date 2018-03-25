# frozen_string_literal: true

module Despeck
  # Extracts text of desired language from the image
  class Ocr
    attr_reader :lang, :source_path

    def initialize(path)
      @source_path = path
    end

    def text(lang: :eng)
      if source_path.end_with?('.pdf')
        res = ''
        for_each_page_image do |path|
          res += RTesseract.new(path, lang: lang).to_s
        end
        res
      else
        RTesseract.new(source_path, lang: lang).to_s
      end
    end

    private

    def for_each_page_image
      paths = []
      Despeck::PdfTools
        .pdf_to_images(source_path).each_with_index do |pic, index|
          tempfile = Tempfile.new(['despeck_page', '.jpg'])
          pic.write_to_file(tempfile.path)
          yield tempfile.path
        end

      paths
    end
  end
end
