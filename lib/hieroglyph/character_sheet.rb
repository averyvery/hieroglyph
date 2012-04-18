module Hieroglyph

  if imagemagick_installed?
    class CharacterSheet

      @@montage_args = {
        "background" => "#ffffff",
        "border" => 20,
        "bordercolor" => "#ffffff",
        "fill" => "#000000",
        "geometry" => "150x150+10+5",
        "label" => "%t",
        "mattecolor" => "#ffffff"
      }

      def initialize(options)
        @options = options
        @output_path = File.join(@options[:output_folder], @options[:name]) + "_characters.png"
        Hieroglyph.delete @output_path
        @files = []
      end

      def add(file)
        @files.push file
      end

      def save
        cmd = 'montage'
        @@montage_args["title"] = @options[:name]
        @@montage_args.each do |arg, value|
          cmd << " -#{arg} #{value}"
        end
        @files.each do |file|
          cmd << " #{file}"
        end
        cmd << " #{@output_path}"
        `#{cmd}`
      end
    end

  else
    # No-op
    class CharacterSheet
      def initialize(*)
        Hieroglyph.log "ImageMagick not detected - skipping character sheet"
      end
      def add(file)
      end
      def save
      end
    end
  end

end
