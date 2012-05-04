require 'spec_helper'

describe Hieroglyph::Font do
  context 'A Font' do

    before :each do
      module Hieroglyph
        def self.log(*)
        end
      end
      @font = Hieroglyph::Font.new({:output_folder => '/tmp', :name => 'font', :glyph_folder => '/tmp'})
    end

    it 'includes files from assets' do
      @font.include('header')
      @font.contents.include?('xml').should eql true
    end

    it 'deletes existing SVG' do
      @path = File.expand_path('/tmp/font.svg')
      system ('touch /tmp/font.svg')
      File.exists?(@path).should eql true
      @font.setup()
      File.exists?(@path).should eql false
    end

    it 'creates a character sheet' do
      @font.character_sheet = nil
      @font.character_sheet.instance_of?(Hieroglyph::CharacterSheet).should eql false
      @font.setup()
      @font.character_sheet.instance_of?(Hieroglyph::CharacterSheet).should eql true
    end

    it 'replaces name token in contents' do
      @font.contents = 'xxx{{NAME}}xxx'
      @font.contents = 'xxx{{NAME}}xxx'
      @font.options[:name] = 'foo'
      @font.set_name
      @font.contents.should eql 'xxxfooxxx'
    end

    it 'writes a file' do
      @path = '/tmp/font.svg'
      system("rm #{@path}")
      File.exists?(@path).should eql false
      @font.output_path = @path
      @font.finish
      File.exists?(@path).should eql true
      File.delete(@path)
    end

    it 'adds to contents' do
      @font.contents = 'foo'
      @font.add('bar')
      @font.contents.should eql 'foobar'
    end

    it 'adds glyphs' do
      @font.output_path = '/tmp/glyphs'
      system("rm -rf #{@font.output_path}")
      Dir::mkdir(@font.output_path)
      system("touch rm -rf #{@font.output_path}/foo.svg")
      @font.character_sheet.should_receive(:add)
      @font.add_glyphs
      system("rm -rf #{@font.output_path}")
    end

  end
end
