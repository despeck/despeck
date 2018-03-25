# frozen_string_literal: true

RSpec.describe Despeck::DominantColorV2 do
  subject { described_class.dominant_color(image) }

  context 'when image has red watermark on it' do
    let(:image) { read_image('red_watermark.jpg') }

    it 'returns RGB of red colour' do
      expect(subject).to eq [218, 107, 99]
    end
  end

  context 'when image has light red watermark on it' do
    let(:image) { read_image('light_red_watermark.jpg') }

    it 'returns RGB of red colour' do
      expect(subject).to eq [244, 228, 228]
    end
  end

  context 'when image has purple watermark on it' do
    let(:image) { read_image('purple_watermark.jpg') }

    it 'returns RGB of purple colour' do
      expect(subject).to eq [185, 157, 183]
    end
  end

  context 'when image has violet watermark on it' do
    let(:image) { read_image('violet_watermark.jpg') }

    it 'returns RGB of purple colour' do
      expect(subject).to eq [204, 198, 245]
    end
  end

  context 'when image has blue watermark on it' do
    let(:image) { read_image('blue_watermark.jpg') }

    it 'returns RGB of blue colour' do
      expect(subject).to eq [169, 198, 224]
    end
  end

  context 'when image has green watermark on it' do
    let(:image) { read_image('green_watermark.jpg') }

    it 'returns RGB of green colour' do
      expect(subject).to eq [172, 205, 172]
    end
  end

  context 'when image has yellow watermark on it' do
    let(:image) { read_image('yellow_watermark.jpg') }

    it 'returns RGB of yellow colour' do
      expect(subject).to eq [243, 244, 129]
    end
  end
end
