require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'run tests'
task :spec do
  sh 'ruby spec/google_map_api_spec.rb'
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*"
end

task :rerack do
  sh "rerun -c rakeup --ignore 'coverage/*'"
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes founc')
    end
  end
end

namespace :quality do
  CODE = 'lib/'.freeze

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
