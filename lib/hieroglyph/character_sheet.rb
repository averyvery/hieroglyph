module Hieroglyph

  class CharacterSheet

    def initialize(options)
      if Hieroglyph.rmagick_installed?
        require 'rmagick'
        @options = options
        @output_path = File.join(@options[:output_folder], @options[:name]) + "_characters.png"
        if File.exist? @output_path
          Hieroglyph.log "  #{@output_path} exists, deleting"
          File.delete @output_path
        end
        @characters = Magick::ImageList.new
      else
        Hieroglyph.log "  ImageMagick not installed, skipping character sheet"
      end
    end

    def add(file, name)
      if Hieroglyph.rmagick_installed?
        character = Magick::Image::read(file).first
        character['Label'] = name
        @characters.push character
      end
    end 

    def save
      if Hieroglyph.rmagick_installed?
        name = @options[:name]
        img = @characters.montage do
          self.background_color = "#ffffff"
          self.border_width = 20
          self.border_color = "#ffffff"
          self.fill = "#000000"
          self.geometry = "150x150+10+5"
          self.matte_color = "#ffffff"
          self.title = name
        end
        img.write(@output_path)
      end
    end

  end

end
