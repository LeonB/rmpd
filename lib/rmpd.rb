module Rmpd
  PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  requires = [
    'rubygems',
    "#{PATH}/lib/metaid.rb",
    "#{PATH}/lib/callbacks.rb",
    "#{PATH}/lib/kernel.rb",
    "#{PATH}/lib/monkeys.rb",
    "#{PATH}/lib/prompt.rb",
    "#{PATH}/lib/player_backend.rb",
    "#{PATH}/lib/player.rb",
    "#{PATH}/lib/state.rb"
  ]
  
  requires.each { |file_or_gem| require file_or_gem }

  APP_CONFIG = YAML.load_file("#{PATH}/config.yml")
end
