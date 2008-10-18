module Rmpd
    requires = [
    'rubygems',
    'yaml',
    'callbacks',
    "lib/conf.rb",
    "lib/metaid.rb",
    #"ext/inheritable_attributes.rb", #I would like this one seen gone
    "lib/kernel.rb",
    "lib/monkeys.rb",
    "lib/prompt.rb",
    "lib/player_backend.rb",
    "lib/player.rb",
    "lib/state.rb"
  ]
  
  #Load all files
  requires.each { |file_or_gem| require file_or_gem }
  
  #Setup the config file
  CONFIG = Conf.new
  CONFIG.file = "config.yml"

  if File.exists? CONFIG.file
    CONFIG.add_hash YAML.load_file(CONFIG.file)
  end
  
  CONFIG.plugins.each do |plugin|
    require(PATH + "/lib/plugins/" + plugin)
  end
end