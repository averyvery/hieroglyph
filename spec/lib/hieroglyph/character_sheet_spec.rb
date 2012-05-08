require 'spec_helper'

describe Hieroglyph::CharacterSheet do
  context 'A CharacterSheet' do

    before :each do
      module Hieroglyph
        def self.log(*)
        end
        def self.header(*)
        end
      end
      File.delete('/tmp/sheet_characters.png') if File.exists?('/tmp/sheet_characters.png')
      @character_sheet = Hieroglyph::CharacterSheet.new({:output_folder => '/tmp', :name => 'sheet'})
      @path = File.expand_path('../../../support/test.svg', __FILE__)
    end

    it 'sets the correct output path' do
      @character_sheet.output_path.should eql '/tmp/sheet_characters.png'
    end

    it 'adds a file with a given name' do
      @character_sheet.add(@path)
      @character_sheet.files.should eql [@path]
    end

    it 'saves the files into one image' do
      @character_sheet.add(@path)
      @character_sheet.save
      File.exists?('/tmp/sheet_characters.png').should be_true
      File.delete('/tmp/sheet_characters.png')
    end

  end
end
