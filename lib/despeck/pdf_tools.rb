# frozen_string_literal: true

module Despeck
  module PdfTools
    class << self
      # Increase to improve image quality, decrease to improve performance
      DEFAULT_DPI = 300

      def pdf_to_images(pdf_path, dpi: DEFAULT_DPI)
        images = []
        for_each_page(pdf_path) do |page_no|
          images << Vips::Image.pdfload(pdf_path, page: page_no, dpi: dpi)
        end
        images
      end

      def images_to_pdf(images, pdf_path)
        doc = nil
        images.each do |pic|
          tempfile = Tempfile.new(['despeck', '.jpg'])
          pic.write_to_file(tempfile.path)

          page_size = pic.size.map{|p| p + in2pt(1) }
          layout = page_size.max == page_size.first ? :landscape : :portrait

          if doc
            doc.start_new_page(size: page_size, layout: layout)
          else
            doc = Prawn::Document.new(page_size: page_size, page_layout: layout)
          end

          doc.image(tempfile.path, position: :left,
                               vposition: :top,
                               fit: pic.size)
        end

        doc.render_file(pdf_path)
      end

      def pages_count(pdf_path)
        PDF::Reader.new(pdf_path).pages.count
      end

      def for_each_page(pdf_path)
        pages_count(pdf_path).times do |page_no|
          yield page_no
        end
      end
    end
  end
end
