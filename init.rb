%w[lib]
  .each do |folder|
    require_relative "#{folder}/init.rb"
  end
