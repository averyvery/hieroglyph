#!/usr/bin/env rake
require "bundler/gem_tasks"

task :test do
	system("rspec spec/lib/hieroglyph/font_spec.rb")
	system("rspec spec/lib/hieroglyph/glyph_spec.rb")
	system("rspec spec/lib/hieroglyph/character_sheet_spec.rb")
	system("rspec spec/lib/hieroglyph/noop_sheet_spec.rb")
end
