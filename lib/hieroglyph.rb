#!/usr/bin/env ruby

module Hieroglyph

  VERSION = "0.0.1"

  def Hieroglyph.log(*args)
    args.each do |arg|
      puts arg
    end
  end

end
