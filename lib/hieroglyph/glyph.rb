#!/usr/bin/env ruby

require "nokogiri"
require "savage"

module Hieroglyph

  class Glyph

    def initialize(file, source)
      @letter = file.gsub(source, "").gsub("/", "").each_char.first
      Hieroglyph.log "  #{@letter} -> reading..."
      @contents = Nokogiri::XML(File.new(file))
      @polygon = @contents.root.at_css("polygon")
      @path = @polygon.nil? ? convert_path: convert_polygon
      flip_paths
    end

    def flip_paths
      @path.subpaths.each do |subpath|
        subpath.directions.each do |direction|
          case direction
          when Savage::Directions::MoveTo
            if(direction.absolute?)
              direction.target.y = flip_y(direction.target.y)
            else
              direction.target.y = -1 * direction.target.y
            end
          when Savage::Directions::VerticalTo
            if(direction.absolute?)
              direction.target = flip_y(direction.target)
            else
              direction.target = -1 * direction.target
            end
          when Savage::Directions::LineTo
            if(direction.absolute?)
              direction.target.y = flip_y(direction.target.y)
            else
              direction.target.y = -1 * direction.target.y
            end
          when Savage::Directions::CubicCurveTo
            if(direction.absolute?)
              direction.control.y = flip_y(direction.control.y)
              direction.target.y = flip_y(direction.target.y)
              if(defined?(direction.control_1) && defined?(direction.control_1.y))
                direction.control_1.y = flip_y(direction.control_1.y)
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
    end

    def convert_path
      @path = @contents.root.at_css("path")["d"] 
      @path = Savage::Parser.parse @path
    end

    def convert_polygon
      Hieroglyph.log "    -> converting polygon to path"
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

    def flip_y(value)
      value = value.to_f
      value = (value - 500) * -1 + 500
    end

    def to_node
      return "<glyph unicode=\"#{@letter}\" d=\"#{@path.to_command}\" />\n"
    end

  end

end
