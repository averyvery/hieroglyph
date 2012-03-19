module Hieroglyph

  class Font

    def initialize(options)
      @options = options
      @output_path = File.join(@options[:output_folder], @options[:name] + ".svg")
      @contents = ""
      setup
      add_glyphs
      finish
    end

    def add_header
      header_path = File.join(File.dirname(__FILE__), "assets/header")
      header = File.open(header_path).read
      header.gsub!("{{NAME}}", @options[:name])
      add header
    end 

    def add_footer
      footer_path = File.join(File.dirname(__FILE__), "assets/footer")
      footer = File.open(footer_path).read
      add footer
    end

    def setup 
      Hieroglyph.log "", "=== Generating #{@options[:name]} ===", ""
      if File.exist? @output_path
        Hieroglyph.log "  #{@output_path} exists, deleting"
        File.delete @output_path
      end
      @character_sheet = CharacterSheet.new(@options)
      add_header
    end

    def finish
      add_footer
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
      Hieroglyph.log "", "  Reading from #{@options[:glyph_folder]}...", ""
      Dir.glob(File.join(@options[:glyph_folder], "*.svg")).each do |file|
        glyph = Glyph.new(file, @options[:glyph_folder])
        @character_sheet.add(file, glyph.name)
        add glyph.to_node
      end
    end
  end

end
