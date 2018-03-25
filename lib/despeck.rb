# frozen_string_literal: true

require 'clamp'
require 'benchmark'
require 'pdf-reader'
require 'prawn'
require 'vips'
require 'rmagick'
require 'rtesseract'

require_relative 'commands/despeck_and_ocr'
require_relative 'commands/remove'
require_relative 'commands/ocr'

require_relative 'despeck/logger'
require_relative 'despeck/dominant_color'
require_relative 'despeck/dominant_color_v2'
require_relative 'despeck/watermark_mask'
require_relative 'despeck/colour_checker'
require_relative 'despeck/watermark_remover'
require_relative 'despeck/pdf_tools'
require_relative 'despeck/ocr'
require_relative 'despeck/cli'

# Prawn helper method are needed to calculate proper pages size
include Prawn::Measurements
