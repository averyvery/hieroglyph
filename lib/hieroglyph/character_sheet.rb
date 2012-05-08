require 'escape'

module Hieroglyph

  class CharacterSheet

    attr_accessor :files, :output_path

    @@montage_args = {
      '-background' => '#ffffff',
      '-fill' => '#000000',
      '-mattecolor' => '#ffffff',
      '-geometry' => '150x150+25+25',
      '-label' => '%t'
    }

    def initialize(options)
      @options = options
      @output_path = File.join(@options[:output_folder], @options[:name]) + '_characters.png'
      Hieroglyph.delete @output_path
      @files = []
    end

    def add(file)
      @files.push file
    end

    def save
      Hieroglyph.header 'Character sheet generated'
      cmd = ['montage']
      @@montage_args['title'] = @options[:name]
      @@montage_args.each do |arg, value|
        cmd.push arg
        cmd.push value
      end
      @files.each do |file|
        cmd.push file
      end
      cmd.push @output_path
      cmd = Escape.shell_command(cmd)
      system(cmd)
      Hieroglyph.log "Saved to #{File.expand_path(@options[:output_folder])}/#{@options[:name]}_characters.svg"
    end
  end

end
