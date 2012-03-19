require 'rmagick'

module Hieroglyph

  class CharacterSheet

    def initialize(options)
      @options = options
      @output_path = File.join(File.dirname(__FILE__), @options[:output_folder], @options[:name], ".png")
      @characters = Magick::ImageList.new
    end

    def add(file)
      @characters.push Magick::Image::read(file).first
    end 

    def save
      img = @characters.montage do
        self.background_color = "#ff0000"
        self.border_width = "20"
        self.fill = "#ff0000"
        self.geometry = "130x194+10+5"
        self.title = @name
      end
      img.write(@output_path)
    end

end
