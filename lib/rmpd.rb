#TODO: create interface-like class for player_backends

# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? Rmpd

  module Rmpd

    VERSION = '0.0.1'
    LIBPATH = ::File.expand_path(::File.dirname(__FILE__))
    PATH = ::File.dirname(LIBPATH)
    CONFIG_FILE = '.config/rmpd.yml'

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
      if not @config
        @config = RubyConfig.new

        #@config.add_source(UserChoices::YamlConfigFileSource, :from_complete_path,
        #  "#{Rmpd.path}/#{Rmpd::CONFIG_FILE}")
        @config.add_source(UserChoices::YamlConfigFileSource, :from_file,
          Rmpd::CONFIG_FILE)
        @config.add_source(UserChoices::CommandLineSource, :usage,
          "Usage: ruby #{$0} [files to play]")
        
        @config.add_option :plugins, :type => [:string] do |commandline|
          commandline.uses_option('-p', '--plugins PLUGINS', 'What plugins to load?')
        end

        only_with_plugins do
          @config.build
        end
      end

      @config
    end
    
    def self.boot
      requires = [
        'rubygems',
        'yaml',
        'callbacks',
        'ruby-config',
        'facets/class/cattr',
        "#{libpath}/monkeys.rb",
        "#{libpath}/logger.rb",
        "#{libpath}/kernel.rb",
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
        self.config.add_subconfig(plugin)
        require("#{Rmpd.libpath}/plugins/#{plugin}")
      end
    end

  end  # module Rmpd
end  # unless defined?

Rmpd.boot()
# EOF
