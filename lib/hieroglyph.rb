IMAGEMAGICK_INSTALLED = !!`convert --veeeersion`.match(/ImageMagick/)

module Hieroglyph

  def self.log(str, title=false)
    if(title)
      puts ""
      puts "=== #{str} ==="
      puts ""
    else
      puts "  #{str}"
    end
  end

  def self.make(options)
    Font.new(options)
  end

  def self.imagemagick_installed?
    ::IMAGEMAGICK_INSTALLED
  end

  def self.delete(file)
    if File.exist? file
      Hieroglyph.log "#{file} exists, deleting"
      File.delete file
    end
  end
end

require 'hieroglyph/version'
require 'hieroglyph/glyph'
require 'hieroglyph/font'
require 'hieroglyph/character_sheet'
require 'hieroglyph/noop_sheet'
