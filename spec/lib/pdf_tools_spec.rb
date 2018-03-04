# frozen_string_literal: true

RSpec.describe Despeck::PdfTools do
  describe '#pdf_to_images' do
    subject { described_class.pdf_to_images(pdf_path, dpi: 100) }

    context 'for single page PDF' do
      let(:pdf_path) { "#{SPEC_ROOT}/fixtures/single_page.pdf" }

      it 'returns Vips::Image' do
        expect(subject.first).to be_a(Vips::Image)
      end
    end

    context 'for multi page PDF' do
      let(:pdf_path) { "#{SPEC_ROOT}/fixtures/3_pages.pdf" }

      it 'returns array of images equal to amount of pages' do
        expect(subject.count).to eq(3)
        subject.each { |im| expect(im).to be_a(Vips::Image) }
      end
    end
  end

  describe '#images_to_pdf' do
    let(:output_pdf_path) { "#{SPEC_ROOT}/tmp/from_images.pdf" }
    let(:images) do
      ['red_watermark.jpg', 'bw.jpg', 'blue_watermark.jpg'].map do |im|
        read_image(im)
      end
    end
    subject { described_class.images_to_pdf(images, output_pdf_path) }

    it 'returns pdf combined of provided images' do
      subject
      expect(described_class.pages_count(output_pdf_path)).to eq(images.count)
    end
  end
end
