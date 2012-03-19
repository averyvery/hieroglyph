RMAGICK_INSTALLED = begin
  require 'rmagick'
  true
rescue Gem::LoadError
  false
end

module Hieroglyph

  VERSION = "0.1"

  def self.log(*args)
    args.each do |arg|
      puts arg
    end
  end

  def self.make(options)
    Font.new(options)
  end

  def self.rmagick_installed?
    ::RMAGICK_INSTALLED
  end
end

require 'hieroglyph/glyph'
require 'hieroglyph/font'
require 'hieroglyph/character_sheet'
