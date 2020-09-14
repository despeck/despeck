module Despeck
  module InstallationCheck
    extend self
    def pre_install
      require 'vips'
    end

    def post_install
    end

    def vips_support_pdf?
      begin
        Vips::Image.pdfload
      rescue Vips::Error => e
        if e.message =~ /class "pdfload" not found/
          puts <<~DOC
          libvips installed without PDF support, please rebuild/reinstall your libvips.
          for more detail instruction go to this page https://libvips.github.io/libvips/install.html
          DOC
          return false
        end
      end
      return true
    end

    def vips_version_supported?
      require 'vips'
      version_only = Vips.version_string.match(/(\d+\.\d+\.\d+)/)[0]
      return true if version_only > "8.6.5"
      puts <<~DOC
      your libvips version is should be minimal at 8.6.5
      libvips installed without PDF support, please rebuild/reinstall your libvips.
      DOC
      return false
    end

    def vips_check_passed?
      passed = true
      passed = false unless vips_version_supported?
      passed = false unless vips_support_pdf
      return passed
    end
  end
end