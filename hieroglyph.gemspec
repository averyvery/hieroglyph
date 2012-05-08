# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hieroglyph/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Doug Avery']
  gem.email         = ['dougunderscorenelson@gmail.com']
  gem.description   = 'Generate a web-ready SVG font from a directory of SVG icons'
  gem.summary       = 'Icon font creator'
  gem.homepage      = 'http://github.com/averyvery/hieroglyph'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.name          = 'hieroglyph'
  gem.require_paths = ['lib']
  gem.version       = Hieroglyph::VERSION

  gem.add_dependency 'nokogiri', '>= 0'
  gem.add_dependency 'savage', '>= 0'
  gem.add_dependency 'escape', '>= 0'
end
