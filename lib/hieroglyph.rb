IMAGEMAGICK_INSTALLED = !!`command convert &>/dev/null && echo "t" || echo "f"`.match(/t/)

module Hieroglyph

  def self.log(str="", pad=2)
    puts str.rjust(str.length + pad)
  end

  def self.colorize(str, color_code, pad)
    Hieroglyph.log("\e[#{color_code}m#{str}\e[0m", pad)
  end

  def self.header(str)
    Hieroglyph.log
    Hieroglyph.log("\033[1m#{str}\e[22m", 0)
  end

  def self.status(str, pad=2)
    colorize(str, 33, pad)
  end

  def self.error(str, pad=2)
    colorize(str, 31, pad)
  end

  def self.success(str, pad=2)
    colorize(str, 32, pad)
  end

  def self.make(options)
    Font.new(options)
  end

  def self.imagemagick_installed?
    ::IMAGEMAGICK_INSTALLED
  end

  def self.delete(file)
    if File.exist? file
      trimmed_file = file.gsub(/\.\//, '')
      Hieroglyph.status "#{trimmed_file} exists, deleting"
      File.delete file
    end
  end
end

require 'hieroglyph/command_line'
require 'hieroglyph/version'
require 'hieroglyph/glyph'
require 'hieroglyph/font'
require 'hieroglyph/character_sheet'
require 'hieroglyph/noop_sheet'
