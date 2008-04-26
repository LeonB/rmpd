class PlayerBackend
  
  def initialize #self.new?s
    raise TypeError, "I am an abstract class"
   end 
  
  #Return a file list of all backends
  def self.backends
  end
  
  def factory(type = nil)
    if type == nil
      file = self.backends[0]
    else
      file = "#{type}.rb"
    end
    
    classname = camelize(file)
    require "#{PATH}/lib/player_backends/#{file}"
    return constantize(classname).new
  end
end