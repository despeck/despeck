# frozen_string_literal: true

module Despeck
  module InstallationCheck
    module_function

    def pre_install
      require 'vips'
      return print_error unless vips_check_passed?

      true
    end

    def post_install; end

    def vips_support_pdf?
      return true if bypassed_vips_pdf_support?

      begin
        Vips::Image.pdfload
      rescue Vips::Error => e
        if e.message =~ /class "pdfload" not found/
          error_messages << <<~DOC
            Libvips installed without PDF support, make sure you have PDFium/poppler-glib installed before building libvips
            For more detail instruction go to this page https://libvips.github.io/libvips/install.html
            To bypass this error, do this `export DESPECK_BYPASS_VIPS_PDF_SUPPORT_CHECK=1`
          DOC
          return false
        end
      end
      true
    end

    def vips_version_supported?
      return true if bypassed_vips_version?

      version_only = Vips.version_string.match(/(\d+\.\d+\.\d+)/)[0]
      return true if version_only > '8.6.5'

      error_messages << <<~DOC
        Your libvips version is should be minimal at 8.6.5
        Please rebuild/reinstall your libvips to >= 8.6.5 .
        To bypass this error, do this `DESPECK_BYPASS_VIPS_VERSION_CHECK=1`
      DOC
      false
    end

    def vips_check_passed?
      passed = true
      passed = false unless vips_version_supported?
      passed = false unless vips_support_pdf?
      passed
    end

    def bypassed_vips_version?
      ['', '1', 'TRUE', 'true'].include?(ENV.fetch('DESPECK_BYPASS_VIPS_VERSION_CHECK', false))
    end

    def bypassed_vips_pdf_support?
      ['', '1', 'TRUE', 'true'].include?(ENV.fetch('DESPECK_BYPASS_VIPS_PDF_SUPPORT_CHECK', false))
    end

    def error_messages
      @error_messages ||= []
    end

    def print_error
      return if error_messages.empty?

      puts <<~ERROR
        #{hr '='}
                Despeck Installation ERROR
        #{hr}
        #{error_messages.join(hr + "\n")}
        #{hr '='}
      ERROR
      @error_message = []
      false
    end

    def hr(line = '-')
      (line * 50)
    end
  end
end
