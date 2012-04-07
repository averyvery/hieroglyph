IMAGEMAGICK_INSTALLED = !!`convert --version`.match(/ImageMagick/)

module Hieroglyph

  VERSION = "0.1.2"

  def self.log(*args)
    args.each do |arg|
      puts arg
    end
  end

  def self.make(options)
    Font.new(options)
  end

  def self.imagemagick_installed?
    ::IMAGEMAGICK_INSTALLED
  end
end

require 'hieroglyph/glyph'
require 'hieroglyph/font'
require 'hieroglyph/character_sheet'
