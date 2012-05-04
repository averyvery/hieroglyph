require 'spec_helper'

describe Hieroglyph::NoopSheet do
  context 'A NoopSheet' do

    before :each do
      module Hieroglyph
        def log(*)
        end
      end
      @character_sheet = Hieroglyph::NoopSheet.new({:output_folder => '/tmp', :name => 'sheet'})
    end

    it 'does nothing' do
      'hi'.should be_false
    end

  end
end
