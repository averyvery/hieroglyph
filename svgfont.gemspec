# -*- encoding: utf-8 -*-
require File.expand_path('../lib/svgfont/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Doug Avery"]
  gem.email         = ["dougunderscorenelson@gmail.com"]
  gem.description   = "Create an SVG font from a directory of SVG icons"
  gem.summary       = "Create an SVG font from a directory of SVG icons"
  gem.homepage      = "http://github.com/averyvery/svgfont"

  gem.files         = "git ls-files".split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "svgfont"
  gem.require_paths = ["lib"]
  gem.version       = Svgfont::VERSION
	gem.add_dependency("nokogiri", ">= 0")
  gem.add_dependency("savage", ">= 0")
	gem.add_dependency("commander", ">= 0")
end
