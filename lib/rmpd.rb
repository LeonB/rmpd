# $Id$

# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? Rmpd

  module Rmpd

    VERSION = '0.0.1'
    LIBPATH = ::File.expand_path(::File.dirname(__FILE__))
    PATH = ::File.dirname(LIBPATH)

    def self.version
      VERSION
    end

    def self.libpath( *args )
      args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
    end

    def self.path( *args )
      args.empty? ? PATH : ::File.join(PATH, *args)
    end
    
    def self.config
      @config ||= Conf.new
    end
    
    def self.boot
      requires = [
        'rubygems',
        'yaml',
        'callbacks',
        "#{libpath}/conf.rb",
        "#{libpath}/kernel.rb",
        "#{libpath}/monkeys.rb",
        "#{libpath}/prompt.rb",
        "#{libpath}/player_backend.rb",
        "#{libpath}/player.rb",
        "#{libpath}/state.rb"
      ]
      
      #Load all files
      requires.each { |file_or_gem| require file_or_gem }
  
      #Setup the config file
      config.file = "config.yml"

      if File.exists? config.file
        config.add_hash YAML.load_file(config.file)
      end
  
      config.plugins.each do |plugin|
        require(PATH + "/lib/plugins/" + plugin)
      end
    end
  
  end  # module Rmpd
end  # unless defined?

Rmpd.boot
# EOF
