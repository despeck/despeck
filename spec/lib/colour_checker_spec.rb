# frozen_string_literal: true

RSpec.describe Despeck::ColourChecker do
  subject { described_class.new(image: image, resize: 0.1) }

  describe '#black_and_white?' do
    context 'when image is black and white only' do
      let(:image) { read_image('bw.jpg') }

      it 'returns true' do
        expect(subject.black_and_white?).to eq true
      end
    end

    context 'when image has red watermark on it' do
      let(:image) { read_image('red_watermark.jpg') }

      it 'returns false' do
        expect(subject.black_and_white?).to eq false
      end
    end

    context 'when image has yellow watermark on it' do
      let(:image) { read_image('yellow_watermark.jpg') }

      it 'returns false' do
        expect(subject.black_and_white?).to eq false
      end
    end

    context 'when image has purple watermark on it' do
      let(:image) { read_image('purple_watermark.jpg') }

      it 'returns false' do
        expect(subject.black_and_white?).to eq false
      end
    end

    context 'when image has green watermark on it' do
      let(:image) { read_image('green_watermark.jpg') }

      it 'returns false' do
        expect(subject.black_and_white?).to eq false
      end
    end

    context 'when image has blue watermark on it' do
      let(:image) { read_image('blue_watermark.jpg') }

      it 'returns false' do
        expect(subject.black_and_white?).to eq false
      end
    end
  end
end
