# frozen_string_literal: true

module Despeck
  # Extracts text of desired language from the image
  class Ocr
    attr_reader :lang, :image_path

    def initialize(image)
      @image_path = image
    end

    def text(lang: :eng)
      RTesseract.new(image_path, lang: lang).to_s
    end
  end
end
