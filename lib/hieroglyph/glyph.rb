require "nokogiri"
require "savage"

module Hieroglyph

  class Glyph

    attr_accessor :name

    SHAPE_HANDLERS = {
      "polygon" => "convert_polygon",
      "path" => "convert_path",
      "circle" => "report_invalid",
      "ellipse" => "report_invalid",
      "line" => "report_invalid",
      "polyline" => "report_invalid",
      "rect" => "report_invalid"
    }

    @@too_many_shapes = false

    def initialize(file, source)
      @name = file.gsub(source, "").gsub("/", "").each_char.first
      @contents = Nokogiri::XML(File.new(file))
      @path = Savage::Path.new
      Hieroglyph.log "  #{@name} -> reading..."
      parse_shapes
      flip_paths
    end

    def parse_shapes
      count = 0
      SHAPE_HANDLERS.each do |type, method|
        contents = @contents.root.at_css(type)
        if contents
          count += 1
          if count > 1
            report_too_many
          else
            self.method(method).call(type, contents)
          end
        end
      end
    end

    def convert_polygon(type, content)
      Hieroglyph.log "       polygon found - converting"
      points = content["points"].split(" ")
      return_path = @path
      Savage::Path.new do |path|
        start_position = points.shift.split(",")
        path.move_to(start_position[0], start_position[1])
        points.each do |point|
          position = point.split(",")
          path.line_to(position[0], position[1])
        end
        path.close_path
        return_path = path
      end
      return_path
    end

    def convert_path(type, content)
      Hieroglyph.log "       path found"
      Savage::Parser.parse content["d"]
    end

    def report_invalid(type, content)
      Hieroglyph.log "       #{type} found - this shape is invalid!"
      Hieroglyph.log "       'make compound path' in your vector tool to fix"
    end

    def report_too_many
      unless @too_many
        Hieroglyph.log "       too many shapes! your icon might look weird as a result"
        @too_many = true
      end
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

    def flip_y(value)
      value = value.to_f
      value = (value - 500) * -1 + 500
    end

    def to_node
      return "<glyph unicode=\"#{@name}\" d=\"#{@path.to_command}\" />\n"
    end

  end

end
