# frozen_string_literal: true

module Despeck
  class CLI < Clamp::Command
    option %w[--version -v], :flag, 'Show version' do
      puts "Version #{Despeck::VERSION}"
      exit(0)
    end

    subcommand('remove', 'Remove watermark', Despeck::Commands::Remove)
  end
end
