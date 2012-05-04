require 'bundler'
Bundler.setup(:test)

require 'rspec'
require 'mocha'
require 'bourne'

require File.expand_path('../../lib/hieroglyph.rb', __FILE__)
require File.expand_path('../../lib/hieroglyph', __FILE__)

Dir["./spec/support/**/*.rb"].each {|f| require f}
