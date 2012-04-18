module Hieroglyph

  class Font

    def initialize(options)
      @contents = ""
      @options = options
      @output_path = File.join(@options[:output_folder], @options[:name] + ".svg")
      setup
      add_glyphs
      finish
    end

    def include(file)
      path = File.join(File.dirname(__FILE__), "assets/#{file}")
      add File.open(path).read
    end

    def setup
      Hieroglyph.header "Generating #{@options[:name]}"
      Hieroglyph.delete @output_path
      @character_sheet = Hieroglyph.imagemagick_installed? ? CharacterSheet.new(@options) : NoopSheet.new
      include "header"
    end

    def set_name
      @contents.gsub!("{{NAME}}", @options[:name])
    end

    def finish
      include "footer"
      set_name
      File.open(@output_path, "w") do |file|
        file.puts @contents
        file.close
      end
      @character_sheet.save
    end

    def add(str)
      @contents << str
    end

    def add_glyphs
      Hieroglyph.log
      Dir.glob(File.join(@options[:glyph_folder], "*.svg")).each do |file|
        glyph = Glyph.new(file, @options[:glyph_folder])
        @character_sheet.add file
        add glyph.to_node
      end
    end
  end

end
