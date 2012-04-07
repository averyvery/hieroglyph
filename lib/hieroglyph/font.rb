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
      Hieroglyph.log "", "=== Generating #{@options[:name]} ===", ""
      if File.exist? @output_path
        Hieroglyph.log "  #{@output_path} exists, deleting"
        File.delete @output_path
      end
      @character_sheet = CharacterSheet.new(@options)
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
      Hieroglyph.log "  Reading from #{@options[:glyph_folder]}..."
      Dir.glob(File.join(@options[:glyph_folder], "*.svg")).each do |file|
        glyph = Glyph.new(file, @options[:glyph_folder])
        @character_sheet.add(file, glyph.name)
        add glyph.to_node
      end
    end
  end

end
