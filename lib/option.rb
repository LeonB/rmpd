module Rmpd
  class Option
    attr_accessor :long, :short, :description, :default, :required, :cast, 
      :value, :processed
    
    def initialize(long, options, &block)
      self.long = long
      options.each do |option_name, option_value|
        self.send("#{option_name}=", option_value)
      end
    end
    
    def inspect
      begin
        do_cast.inspect
      rescue
        super
      end
    end
    
    def value
      return value_from_config_file if value_from_config_file
      return value_from_commandline if value_from_commandline
      return self.default
    end
    
    def value_from_config_file
      Rmpd.config_file[self.long.to_s]
    end
    
    def value_from_commandline
      
    end
    
    def value=(value)
      if cast == Array and value.is_a?(String)
        value.split!(/[\s,]/)
      elsif cast == Array and value.is_a?(Array)
        value = value.to_a
      else
        raise "Cast: #{cast} not know"
      end
      @value = value
    end
    
    def to_s
      value.to_s
    end
    
    def method_missing(id, *args, &block)
      self.value.send(id, *args, &block)
    end
  end
end