IMAGEMAGICK_INSTALLED = !!`command convert &>/dev/null && echo "t" || echo "f"`.match(/t/)

module Hieroglyph

  def self.log(str="", pad=2)
    puts str.rjust(str.length + pad)
  end

  def self.header(str)
    puts ""
    puts "=== #{str} ==="
    puts ""
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
      Hieroglyph.log "#{trimmed_file} exists, deleting"
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
