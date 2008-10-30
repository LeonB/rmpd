# $Id$

# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? Rmpd

  module Rmpd

    VERSION = '0.0.1'
    LIBPATH = ::File.expand_path(::File.dirname(__FILE__))
    PATH = ::File.dirname(LIBPATH)
    CONFIG_FILE = 'config.yml'

    def self.version
      VERSION
    end

    def self.libpath( *args )
      args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
    end

    def self.path( *args )
      args.empty? ? PATH : ::File.join(PATH, *args)
    end
    
    def self.config_file
      @config_file ||= load_config
    end
    
    def self.config
      if not @config
        @config = Config.new
        @config.option :plugins, :description => 'What plugins to load?', 
          :short => 'p', :cast => Array
      end
      @config
    end
    
    def self.load_config
        raise "Config file: #{CONFIG_FILE} not found" if not File.exists?(CONFIG_FILE)
        YAML.load_file(CONFIG_FILE)
    end
    
    def self.boot
      requires = [
        'rubygems',
        'yaml',
        'callbacks',
        'facets/class/cattr',
        "#{libpath}/config.rb",
        "#{libpath}/option.rb",
        "#{libpath}/kernel.rb",
        "#{libpath}/monkeys.rb",
        "#{libpath}/prompt.rb",
        "#{libpath}/player_backend.rb",
        "#{libpath}/player.rb",
        "#{libpath}/state.rb",
        "#{libpath}/server.rb",
      ]
      
      #Load all files
      requires.each { |file_or_gem| require file_or_gem }
    end
    
    def self.load_plugins
      config.plugins.each do |plugin|
        self.config.class.send(:attr_accessor, plugin)
        self.config.send("#{plugin}=", Config.new)
        require("#{Rmpd.libpath}/plugins/#{plugin}")
      end
    end
  
    end  # module Rmpd
  end  # unless defined?

  Rmpd.boot()
  # EOF