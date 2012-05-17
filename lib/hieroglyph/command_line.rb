require "optparse"
require File.expand_path(File.dirname(__FILE__) + '/../hieroglyph')

module Hieroglyph

  class CommandLine

    BANNER = <<-EOS

Usage: hieroglyph OPTIONS

Run hieroglyph to generate an SVG font from a folder of SVG glyphs.

Report any problems here: http://github.com/averyvery/hieroglyph/issues

Options:
    EOS

    def initialize
      @execute = true
      parse_options
      if @execute
        font = Hieroglyph.make @options
        Hieroglyph.success "#{@options[:name]} generated saved to #{File.expand_path(@options[:output_folder])}/#{@options[:name]}.svg"
        Hieroglyph.log "Single characters: #{font.characters.join(',')}"
        Hieroglyph.log "Unicode characters: #{font.unicode_values.join(',')}"
        Hieroglyph.log
        Hieroglyph.log "To create a full set of webfonts, upload to http://www.fontsquirrel.com/fontface/generator"
        Hieroglyph.log "If you're having trouble uploading SVGs, try converting to a TTF first using http://www.freefontconverter.com"
        Hieroglyph.log
      end
    end

    def parse_options
      @options = {
        :name => "MyFont",
        :output_folder => "./",
        :glyph_folder => "glyphs"
      }
      @option_parser = OptionParser.new do |opts|
        opts.on("-n", "--name NAME", "name of the font you want generated") do |name|
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
          Hieroglyph.log "Example glyphs saved to #{Dir.pwd}/glyphs"
          glyphs_path = File.join(File.dirname(__FILE__), "assets/glyphs")
          exec "cp -r #{glyphs_path} ./"
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
