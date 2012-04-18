require 'spec_helper'

describe Hieroglyph::CharacterSheet do
  context "A CharacterSheet" do
    before :each do
      @characters = stub(:push)
      Magick::ImageList.stubs(:new).returns(@characters)

      @character_sheet = Hieroglyph::CharacterSheet.new({:output_folder => '/tmp', :name => 'sheet'})
    end

    it "adds a file with a given name" do
      character = stub(:[]=)
      Magick::Image.stubs(:read).returns([character])

      @character_sheet.add('a file', 'some name')

      Magick::Image.should have_received(:read).with('a file')
      character.should have_received(:[]=).with('Label', 'some name')
      @characters.should have_received(:push).with(character)
    end

    it 'saves the files into one image' do
      image = stub(:write)

      @characters.stubs(:montage).yields.returns(image)

      @character_sheet.stubs(:background_color=)
      @character_sheet.stubs(:border_width=)
      @character_sheet.stubs(:border_color=)
      @character_sheet.stubs(:fill=)
      @character_sheet.stubs(:geometry=)
      @character_sheet.stubs(:matte_color=)
      @character_sheet.stubs(:title=)

      @character_sheet.save

      @character_sheet.should have_received(:background_color=).with("#ffffff")
      @character_sheet.should have_received(:border_width=).with(20)
      @character_sheet.should have_received(:border_color=).with("#ffffff")
      @character_sheet.should have_received(:fill=).with("#000000")
      @character_sheet.should have_received(:geometry=).with("150x150+10+5")
      @character_sheet.should have_received(:matte_color=).with("#ffffff")
      @character_sheet.should have_received(:title=).with('sheet')

      image.should have_received(:write).with('/tmp/sheet_characters.png')
    end
  end
end
