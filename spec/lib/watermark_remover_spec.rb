# frozen_string_literal: true

RSpec.describe Despeck::WatermarkRemover do
  let(:no_contrast)     { true }
  let(:no_black)        { true }
  let(:watermark_color) { nil }
  let(:output_file)     { "#{SPEC_ROOT}/tmp/output.jpg" }
  let(:output_image)    { read_image(output_file) }
  subject do
    described_class.new(
      no_contrast:      no_contrast,
      no_black:         no_black,
      watermark_color:  watermark_color
    ).remove_watermark(input_file, output_file)
  end

  before(:each) { subject }
  after(:each) { FileUtils.rm(output_file) }

  shared_examples 'watermark remover' do
    it 'removes watermark correctly & leaves only BW scan' do
      expect(Despeck::ColourChecker.new(image: output_image).black_and_white?)
        .to eq true
    end
  end

  context 'for red watermark' do
    let(:input_file) { "#{SPEC_ROOT}/fixtures/red_watermark.jpg" }

    it_behaves_like 'watermark remover'
  end

  context 'for green watermark' do
    let(:input_file) { "#{SPEC_ROOT}/fixtures/green_watermark.jpg" }

    it_behaves_like 'watermark remover'
  end

  context 'for purple watermark' do
    let(:input_file) { "#{SPEC_ROOT}/fixtures/purple_watermark.jpg" }

    it_behaves_like 'watermark remover'
  end

  context 'for yellow watermark' do
    let(:input_file) { "#{SPEC_ROOT}/fixtures/yellow_watermark.jpg" }

    it_behaves_like 'watermark remover'
  end
end
