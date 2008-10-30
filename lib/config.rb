require 'optiflag'

module Rmpd
  class Config
    
    def initialize
      super #initialize ostruct
    end
  
    def add_hash(hash)
      hash.each_pair do |name, val|
        if val.is_a? Hash
          self.send("#{name}=", Config.new) if not self.send("#{name}")
          self.send("#{name}").add_hash(val)
        else
          self.send("#{name}=", val)
        end
      end
    end

    def option(long, options, &block)
      self.options[long.to_sym] = Option.new(long, options, &block)
      define_option_methods(long)
    end
    
    def define_option_methods(method_name)
      method_name.to_s.downcase!
      
      self.class.send(:define_method, method_name) do
        self.options[method_name.to_sym]
      end
      self.class.send(:define_method, "#{method_name}=") do |value|
        self.options[method_name.to_sym].value = value
      end
    end
    
    def options(&block)      
      return instance_eval(&block) if block_given?
      return @options ||= {}
    end
    
    def parse
      parse_config_file
      parse_commandline_arguments
    end
    
    def parse_commandline_arguments
      
    end
    
    def parse_config_file
      
    end
    
  end
end 