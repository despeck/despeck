# frozen_string_literal: true

module Despeck
  # Command line interface
  class CLI < Clamp::Command
    option %w[--version -v], :flag, 'Show version' do
      puts "Version #{Despeck::VERSION}"
      exit(0)
    end

    subcommand(
      'despeck',
      'Extract text from the despecked image or pdf',
      Despeck::Commands::DespeckAndOcr
    )
    subcommand('remove', 'Remove watermark', Despeck::Commands::Remove)
    subcommand('ocr', 'Extract text from the image', Despeck::Commands::Ocr)
  end
end
