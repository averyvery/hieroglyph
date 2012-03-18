#!/usr/bin/env ruby

require "hieroglyph/version"
require "nokogiri"
require "savage"

module Hieroglyph

  ALLOWED = ["example", "make"]

  def Hieroglyph.log(str)
    puts str
  end

  class Glyph

    def initialize(file, source)

      @letter = file.gsub(source, "").gsub("/", "").each_char.first
      Hieroglyph.log " "
      Hieroglyph.log "Glyph: #{@letter}"

      @contents = Nokogiri::XML(File.new(file))
      @polygon = @contents.root.at_css("polygon")
      @path = @polygon.nil? ? convert_path: convert_polygon

      Hieroglyph.log "....path found. Parsing subpaths."

      @path.subpaths.each do |subpath|
        subpath.directions.each do |direction|
          case direction
          when Savage::Directions::MoveTo
            if(direction.absolute?)
              direction.target.y = flip(direction.target.y)
            else
              direction.target.y = -1 * direction.target.y
            end
          when Savage::Directions::VerticalTo
            if(direction.absolute?)
              direction.target = flip(direction.target)
            else
              direction.target = -1 * direction.target
            end
          when Savage::Directions::LineTo
            if(direction.absolute?)
              direction.target.y = flip(direction.target.y)
            else
              direction.target.y = -1 * direction.target.y
            end
          when Savage::Directions::CubicCurveTo
            if(direction.absolute?)
              direction.control.y = flip(direction.control.y)
              direction.target.y = flip(direction.target.y)
              if(defined?(direction.control_1) && defined?(direction.control_1.y))
                direction.control_1.y = flip(direction.control_1.y)
              end
            else
              direction.control.y = -1 * direction.control.y
              direction.target.y = -1 * direction.target.y
              if(defined?(direction.control_1) && defined?(direction.control_1.y))
                direction.control_1.y = -1 * direction.control_1.y
              end
            end
          end
        end
      end
      Hieroglyph.log "....subpaths parsed and saved."
      @path = @path.to_command
    end

    def convert_path
      @path = @contents.root.at_css("path")["d"] 
      @path = Savage::Parser.parse @path
    end

    def convert_polygon
      Hieroglyph.log "....polygon found. Converting to path..."
      points = @polygon["points"].split(" ")
      Savage::Path.new do |path|
        start_position = points.shift.split(",")
        path.move_to(start_position[0], start_position[1])
        points.each do |point|
          position = point.split(",")
          path.line_to(position[0], position[1])
        end
        path.close_path
      end
    end

    def flip(value)
      value = value.to_f
      value = (value - 500) * -1 + 500
    end

    def to_node
      return "<glyph unicode=\"#{@letter}\" d=\"#{@path}\" />\n"
    end

  end

  class Font

    attr_accessor :dest_path

    def initialize(name, source, destination)
      @name = name
      @source = source
      @destination = destination
      @source_path = File.join(@source, "*.svg")
      @dest_path = File.join(@destination, @name + ".svg")
      @contents = ""
      setup
      add_glyphs
      finish
    end

    def add_header
      write File.open(File.join(File.dirname(__FILE__), "hieroglyph/header")).read.gsub("{{NAME}}", @name)
    end 

    def add_footer
      write File.open(File.join(File.dirname(__FILE__), "hieroglyph/footer")).read
    end

    def setup 
      if File.exist? @dest_path
        Hieroglyph.log "#{@dest_path} exists, deleting..."
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

    def write(str)
      @contents << str
    end

    def add_glyphs
      Hieroglyph.log "Reading from #{@source_path}"
      Dir.glob(@source_path).each do |file|
        glyph = Glyph.new(file, @source)
        write(glyph.to_node)
      end
    end
  end

  class Interface
    def initialize(args) 
      @name = args[1] || "MyFont"
      @source = args[2] || "glyphs"
      @destination = args[3] || "."
      method_name = args[0]
      if ALLOWED.include? method_name
        send method_name
      else
        Hieroglyph.log "NOPE. Allowed methods are: " + ALLOWED.join(", ")
      end
    end

    def example
      Hieroglyph.log "Outputting example glyphs"
      glyph_path = File.join(File.dirname(__FILE__), "hieroglyph/glyphs")
      exec "cp -r #{glyph_path} ./"
    end

    def make
      @font = Font.new(@name, @source, @destination)
      Hieroglyph.log " "
      Hieroglyph.log "'#{@name}' saved to #{@font.dest_path}"
      Hieroglyph.log "To create a full set of webfont, upload to http://www.fontsquirrel.com/fontface/generator"
    end
  end

end
