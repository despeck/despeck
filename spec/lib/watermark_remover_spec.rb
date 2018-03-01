# frozen_string_literal: true

RSpec.describe Despeck::WatermarkRemover do
  let(:add_contrast)    { false }
  let(:add_black)       { false }
  let(:watermark_color) { nil }
  let(:output_image) do
    described_class.new(
      add_contrast:    add_contrast,
      add_black:       add_black,
      watermark_color: watermark_color
    ).remove_watermark(input_image)
  end

  before(:each) { subject }

  shared_examples 'watermark remover' do
    let(:params) { { image: output_image, resize: 0.1 } }

    it 'removes watermark correctly & leaves only BW scan' do
      expect(Despeck::ColourChecker.new(params).black_and_white?)
        .to eq true
    end
  end

  context 'for red watermark' do
    let(:input_image) { read_image('red_watermark.jpg') }

    it_behaves_like 'watermark remover'
  end

  context 'for green watermark' do
    let(:input_image) { read_image('green_watermark.jpg') }

    it_behaves_like 'watermark remover'
  end

  context 'for purple watermark' do
    let(:input_image) { read_image('purple_watermark.jpg') }

    it_behaves_like 'watermark remover'
  end

  context 'for yellow watermark' do
    let(:input_image) { read_image('yellow_watermark.jpg') }

    it_behaves_like 'watermark remover'
  end

  context 'for image without watermark' do
    let(:input_image) { read_image('bw.jpg') }

    it 'returns no image' do
      expect(output_image).to be_nil
    end
  end
end
