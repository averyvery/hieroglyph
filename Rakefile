desc 'Run Rspec'
task :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new('spec')
end

task :default => :spec

desc 'Install the gem'
task :install do
  sh 'gem build *.gemspec'
  sh 'gem install *.gem'
  sh 'rm *.gem'
end
