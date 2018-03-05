# frozen_string_literal: true

# Everything related to logging and output for the gem
module Despeck
  def self.logger
    @logger ||=
      begin
        l = Logger.new($stdout)
        l.level = Logger::ERROR
        l
      end
  end

  def self.apply_logger_level(debug = false)
    logger.level = debug ? Logger::DEBUG : Logger::ERROR
  end

  def self.with_level(level = Logger::ERROR)
    prev_level = logger.level
    logger.level = level

    yield

    logger.level = prev_level
  end
end
