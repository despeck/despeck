# frozen_string_literal: true

require 'bundler/setup'
require 'despeck'

SPEC_ROOT = __dir__

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def read_image(filename)
  path = filename.include?('/') ? filename : "#{SPEC_ROOT}/fixtures/#{filename}"
  Vips::Image.new_from_file(path)
end
