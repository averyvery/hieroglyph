require 'spec_helper'

describe Hieroglyph::Glyph do
  context 'A Glyph' do

    before :each do
      module Hieroglyph
        def self.log(*)
        end
        def self.header(*)
        end
      end
      system('rm -rf /tmp/glyphs/')
      system('mkdir /tmp/glyphs/')
      path_to_test = File.expand_path('../../../support/test.svg', __FILE__)
      system("cp #{path_to_test} /tmp/glyphs/a-test.svg")
      path_to_test = File.expand_path('../../../support/test-polygon.svg', __FILE__)
      system("cp #{path_to_test} /tmp/glyphs/b-polygon.svg")

      @font = Hieroglyph::Font.new({:output_folder => '/tmp', :name => 'font', :glyph_folder => '/tmp/glyphs'})
      @glyph = Hieroglyph::Glyph.new('/tmp/glyphs/a-test.svg', '/tmp/glyphs', @font)

    end

    after :each do
      system('rm /tmp/glyphs/a-test.svg')
    end

    it 'sets a name when given simple letters' do
      @glyph.set_name('/tmp/glyphs/a-file.svg', '/tmp/glyphs/')
      @glyph.name.should eql 'a'
    end

    it 'sets a name when given a special characters' do
      @glyph.set_name('/tmp/glyphs/{-file.svg', '/tmp/glyphs/')
      @glyph.name.should eql '{'
    end

    it 'sets a name when given a question mark' do
      @glyph.set_name('/tmp/glyphs/?-file.svg', '/tmp/glyphs/')
      @glyph.name.should eql '?'
    end

    it 'sets a name when given a dash' do
      @glyph.set_name('/tmp/glyphs/--file.svg', '/tmp/glyphs/')
      @glyph.name.should eql '-'
    end

    it 'sets a name when given a single-letter filename' do
      @glyph.set_name('/tmp/glyphs/a.svg', '/tmp/glyphs/')
      @glyph.name.should eql 'a'
    end

    it 'sets a name when given unicode' do
      @glyph.set_name('/tmp/glyphs/&#xf8ff;-file.svg', '/tmp/glyphs/')
      @glyph.name.should eql '&#xf8ff;'
    end

    it 'adds single characters to the character array' do
      @font.characters = []
      @glyph.set_name('/tmp/glyphs/a-file.svg', '/tmp/glyphs/')
      @font.characters.should eql ['a']
    end

    it 'adds unicode names to the unicode array' do
      @font.unicode_values = []
      @glyph.set_name('/tmp/glyphs/&#xf8ff;-file.svg', '/tmp/glyphs/')
      @font.unicode_values.should eql ['F8FF']
    end

    it 'calls appropriate method when given a shape' do
      @glyph.should_receive(:convert_polygon)
      @glyph.contents = Nokogiri::XML('<?xml version="1.0" encoding="utf-8"?><svg><polygon /></svg>')
      @glyph.parse_shapes
    end

    it 'reports too many if given multiple shapes' do
      @glyph.should_receive(:report_too_many).exactly(2).times
      @glyph.contents = Nokogiri::XML('<?xml version="1.0" encoding="utf-8"?><svg><polygon points="2,2" /><path fill="" /></svg>')
      @glyph.stub!(:convert_path)
      @glyph.stub!(:convert_polygon)
      @glyph.parse_shapes
    end

    it 'converts polygons to paths' do
      path_to_test = File.expand_path('../../../support/test-polygon.svg', __FILE__)
      content = Nokogiri::XML(File.new(path_to_test)).at_css('polygon')
      path = 'M745.365 600.357 499.029 354.03499999999997 252.729 600.357 131.5 479.03 377.77 232.78200000000004 377.759 232.77099999999996 500.882 109.64300000000003 868.5 477.229Z'
      @glyph.convert_polygon('', content).to_command.should eql path
    end

    it 'gets paths from path strings' do
      Savage::Parser.should_receive(:parse)
      path_to_test = File.expand_path('../../../support/test.svg', __FILE__)
      content = Nokogiri::XML(File.new(path_to_test)).at_css('path')
      @glyph.stub!(:flip)
      @glyph.convert_path('', content)
    end

    it 'flips paths' do
      normal_path = File.open(File.expand_path('../../../support/normal_path', __FILE__)).read
      flipped_path = File.open(File.expand_path('../../../support/flipped_path', __FILE__)).read
      path = Savage::Parser.parse normal_path
      new_path = @glyph.flip(path).to_command + "\n"
      new_path.should eql flipped_path
    end

    it 'flips y values around the 500 axis, subtracts 25' do
      @glyph.flip_y(750).should eql 225.0
    end

    it 'flips y values around the 500 axis, subtracts 25' do
      @glyph.flip_y(999).should eql -24.0
    end

    it 'flips y values around the 500 axis, subtracts 25' do
      @glyph.flip_y(500).should eql 475.0
    end

    it 'converts paths to XML nodes' do
      @glyph.path = Savage::Path.new
      @glyph.path.stub!(:to_command).and_return('foo')
      @glyph.to_node.should eql "<glyph unicode=\"a\" d=\"foo\" />\n"
    end

  end
end
