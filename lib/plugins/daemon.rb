#Daemonize the player (with some specific commandline option?)
module Rmpd
  class Daemon
    require 'daemons'
    cattr_accessor :daemon

    Rmpd.config.daemon.add_option :daemonize, :type => :boolean,
      :default => false do |commandline|
      commandline.uses_switch('-d', '--daemonize', 'Daemonize process')
    end
    
    def status_message
      print "#{self.status}\n"
    end
  
    #method_chain?
    def self.boot_with_daemonize
      self.daemon = Daemons.call do
        Rmpd.server.start
      end
    end
  
    #after_boot :status_message
    
  end
end