require 'spec_helper'

describe Hieroglyph::NoopSheet do
  context 'A NoopSheet' do

    before :each do
      module Hieroglyph
        def log(*)
        end
        def self.header(*)
        end
      end
      @character_sheet = Hieroglyph::NoopSheet.new({:output_folder => '/tmp', :name => 'sheet'})
    end

    it 'should execute add' do
      @character_sheet.add('whatever')
    end

    it 'should not save files' do
      @character_sheet.save
      File.exists?('/tmp/sheet_characters.png').should be_false
    end

  end
end
