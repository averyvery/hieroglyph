module Hieroglyph

  class Font

    def initialize(options)
      @options = options
      @dest_path = File.join(@options[:output_folder], @options[:name] + ".svg")
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
      @character_sheet = CharacterSheet.new(@options)
      Hieroglyph.log "", "=== Generating #{@options[:name]} ===", ""
      if File.exist? @dest_path
        Hieroglyph.log "  #{@dest_path} exists, deleting..."
        File.delete @dest_path
      end
      add_header
    end

    def finish
      add_footer
      File.open(@dest_path, "w") do |file|
        file.puts @contents
        file.close
      end
    end

    def add(str)
      @contents << str
    end

    def add_glyphs
      Hieroglyph.log "  Reading from #{@options[:glyph_folder]}...", ""
      Dir.glob(File.join(@options[:glyph_folder], "*.svg")).each do |file|
        glyph = Glyph.new(file, @options[:glyph_folder])
        @character_sheet.add(file)
        add glyph.to_node
      end
    end
  end

end
