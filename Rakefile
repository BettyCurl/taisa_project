require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'run tests'
task :spec do
  sh 'ruby spec/google_map_api_spec.rb'
end

namespace :quality do
  CODE = 'lib/'

  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  task :rubocop do
    sh 'rubocop'
  end

  task :reek do
    sh 'reek'
  end

  task :flog do
    sh "flog #{CODE}"
  end
end
