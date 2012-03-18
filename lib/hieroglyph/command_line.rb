#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/../hieroglyph')

module Hieroglyph

  class CommandLine

    BANNER = <<-EOS

Usage: hieroglyph OPTIONS

Run hieropgly to generate an SVG font from a folder of SVG glyphs.

Options:
    EOS

    @execute = true

    def initialize
      parse_options
      if @execute
        Font.new(@options)
        Hieroglyph.log "", "  Saved to #{@options[:destination]}", "", "=== #{@options[:name]} generated ===", ""
        Hieroglyph.log "To create a full set of webfonts, upload to:", "http://www.fontsquirrel.com/fontface/generator", ""
      end
    end

    def parse_options
      @options = {
        :name => "MyFont",
        :output_folder => "./",
        :glyph_folder => "glyphs"
      }
      @option_parser = OptionParser.new do |opts|
        opts.on("-n", "--name NAME", 'name of the font you want generated') do |name|
          @options[:name] = name
        end
        opts.on("-o", "--output OUTPUT_FOLDER", "where to output the generated font") do |output_folder|
          @options[:output_folder] = output_folder
        end
        opts.on("-g", "--glyphs GLYPH_FOLDER", "where to find glyphs to generate from") do |glyph_folder|
          @options[:glyph_folder] = glyph_folder
        end
        opts.on("-e", "--example", "output set of example glyphs") do |output_folder|
          @execute = false
          Hieroglyph.log "=== Outputting example glyphs ==="
          glyph_path = File.join(File.dirname(__FILE__), "hieroglyph/assets/glyphs")
          exec "cp -r #{glyph_path} #{output_folder}/glyphs"
          exit
        end
        opts.on_tail('-v', '--version', 'display Hieroglyph version') do
          @execute = false
          Hieroglyph.log "Hieroglyph version #{Hieroglyph::VERSION}"
        end
      end
      @option_parser.banner = BANNER
      @option_parser.parse!(ARGV)
    end

  end

end
