#!/usr/bin/env ruby

require "svgfont/version"
require "nokogiri"
require "savage"

module Svgfont

  class Font

    def initialize
      @contents = File.open(File.join(File.dirname(__FILE__), "svgfont/header")).read.gsub("{{NAME}}", name)
      do_it
      @contents << File.open(File.join(File.dirname(__FILE__), "svgfont/footer")).read
      File.open(File.join(@destination, @name + ".svg"), "w") do |file|
        file.puts @contents
        file.close
      end
    end

    def makepath(polygon)
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

    def do_it

      Dir.glob(File.join(source, "*.svg")).each do |svg_path|

        letter = svg_path.gsub(source, "").gsub("/", "").each_char.first
        puts "Reading #{letter}..."

        file = File.open(svg_path).read

        if(file.match('polygon'))
          polygon = file.scan(/(?<=\spoints\=["']).*?(?=["'])/m)[0].gsub(/[\n\r\t]/, " ").squeeze(" ")
          path = makepath(polygon)
        else
          path = file.scan(/(?<=\sd\=["']).*?(?=["'])/m)[0].gsub(/[\n\r\t]/, " ").squeeze(" ")
          path = Savage::Parser.parse path
        end

        path.subpaths.each do |subpath|
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
      @font = Font.new
      @font.save
      puts "Font created: #{@name} -> #{@destination}#{@name}.svg"
      puts "To create a full webfont, upload to http://www.fontsquirrel.com/fontface/generator"
    end
  end

end
