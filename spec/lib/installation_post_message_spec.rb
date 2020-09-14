# frozen_string_literal: true

require 'despeck/installation_post_message'
RSpec.describe Despeck::InstallationPostMessage do
  after { Despeck::InstallationPostMessage.build }
  describe '#vips_version_supported?' do
    subject { Despeck::InstallationPostMessage.vips_version_supported? }
    context 'when below supported version' do
      before { allow(Vips).to receive(:version_string).and_return('8.6.4') }
      it { should be_falsey }
    end
    context 'when include in supported version' do
      before { allow(Vips).to receive(:version_string).and_return('8.7.4') }
      it { should be_truthy }
    end
  end

  describe '#vips_support_pdf?' do
    subject { Despeck::InstallationPostMessage.vips_support_pdf? }
    context 'when build without pdfload' do
      before do
        allow(Vips::Image).to receive(:pdfload)
          .and_raise(Vips::Error, 'class "pdfload" not found')
      end
      it { should be_falsey }
    end
    context 'when build with pdf support' do
      before do
        allow(Vips::Image).to receive(:pdfload)
          .and_return(true)
      end
      it { should be_truthy }
    end
  end
end
