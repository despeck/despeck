# frozen_string_literal: true

RSpec.describe Despeck::DominantColor do
  subject { described_class.dominant_color(image) }

  context 'when image has red watermark on it' do
    let(:image) { read_image('red_watermark.jpg') }

    it 'returns primary red color' do
      expect(subject).to eq 'FF0000'
    end
  end

  context 'when image has purple watermark on it' do
    let(:image) { read_image('purple_watermark.jpg') }

    it 'returns primary red color' do
      expect(subject).to eq 'FF0000'
    end
  end

  context 'when image has blue watermark on it' do
    let(:image) { read_image('blue_watermark.jpg') }

    it 'returns primary blue color' do
      expect(subject).to eq '0000FF'
    end
  end

  context 'when image has green watermark on it' do
    let(:image) { read_image('green_watermark.jpg') }

    it 'returns primary green color' do
      expect(subject).to eq '00FF00'
    end
  end

  context 'when image has yellow watermark on it' do
    let(:image) { read_image('yellow_watermark.jpg') }

    it 'returns primary green color' do
      expect(subject).to eq '00FF00'
    end
  end
end
