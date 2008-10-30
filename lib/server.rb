module Rmpd
  class Server
    cattr_accessor :player
    include Callbacks
    
    def self.boot
      #self.get_config
      self.player = Player.new
    end
    
    def self.run
      begin
        loop do
          p "#{Time.now}: still running"
          sleep 10
        end
      ensure #always do this, assertion or not
        self.exit
      end
    end
    
    def self.start
      self.boot
      self.run
    end
    
    def self.exit
      p 'exiting'
    end

    add_class_callback_methods :boot, :exit
  end #Server
end #Rmpd