require 'hieroglyph/glyph'
require 'hieroglyph/font'
require 'hieroglyph/character_sheet'

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

end
