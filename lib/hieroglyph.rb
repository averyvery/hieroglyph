#!/usr/bin/env ruby

require "hieroglyph/version"
require "nokogiri"
require "savage"

module Hieroglyph

  class Font

    attr_accessor :dest_path

    def initialize(name, source, destination)
      @name = name
      @source = source
      @destination = destination
      @source_path = File.join(@source, "*.svg")
      @dest_path = File.join(@destination, @name + ".svg")
      start_file
      add_paths
      end_file
    end

    def save
      File.open(@dest_path, "w") do |file|
        file.puts @contents
        file.close
      end
    end

    def start_file
      @contents = File.open(File.join(File.dirname(__FILE__), "hieroglyph/header")).read.gsub("{{NAME}}", @name)

    end

    def end_file
      @contents << File.open(File.join(File.dirname(__FILE__), "hieroglyph/footer")).read
    end

    def make_path(polygon)
      points = polygon.split(" ")
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
      if(value > 500)
        500 - (value - 500)
      else
        500 + (500 - value)
      end
    end

    def add_paths

      puts "Reading from #{@source_path}"
      Dir.glob(@source_path).each do |svg_path|

        letter = svg_path.gsub(@source, "").gsub("/", "").each_char.first
        puts " "
        puts "Glyph: #{letter}"

        file = File.open(svg_path).read

        if(file.match('polygon'))
          puts "....polygon found. Converting to path."
          polygon = file.scan(/(?<=\spoints\=["']).*?(?=["'])/m)[0].gsub(/[\n\r\t]/, " ").squeeze(" ")
          path = make_path(polygon)
          puts "....conversion complete. Parsing subpaths."
        else
          puts "....paths found. Parsing subpaths."
          path = file.scan(/(?<=\sd\=["']).*?(?=["'])/m)[0].gsub(/[\n\r\t]/, " ").squeeze(" ")
          path = Savage::Parser.parse path
        end

        path.subpaths.each do |subpath|
          subpath.directions.each do |direction|
            case direction
            when Savage::Directions::MoveTo
              if(direction.absolute?)
                direction.target.y = self.flip(direction.target.y)
              else
                direction.target.y = -1 * direction.target.y
              end
            when Savage::Directions::VerticalTo
              if(direction.absolute?)
                direction.target = self.flip(direction.target)
              else
                direction.target = -1 * direction.target
              end
            when Savage::Directions::LineTo
              if(direction.absolute?)
                direction.target.y = self.flip(direction.target.y)
              else
                direction.target.y = -1 * direction.target.y
              end
            when Savage::Directions::CubicCurveTo
              if(direction.absolute?)
                direction.control.y = self.flip(direction.control.y)
                direction.target.y = self.flip(direction.target.y)
                if(defined?(direction.control_1) && defined?(direction.control_1.y))
                  direction.control_1.y = self.flip(direction.control_1.y)
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
        puts "....subpaths parsed and saved."
        path = path.to_command
        @contents << "<glyph unicode=\"#{letter}\" d=\"#{path}\" />\n"
      end
    end
  end

  class CLI
    def initialize(args) 
      @args = args
      @name = @args[0] || "myfont"
      @source = @args[1] || "glyphs"
      @destination = @args[2] || "."
      execute
    end

    def execute
      @font = Font.new(@name, @source, @destination)
      @font.save
      puts " "
      puts "'#{@name}' saved to #{@font.dest_path}"
      puts "To create a full webfont, upload to http://www.fontsquirrel.com/fontface/generator"
    end
  end

end
