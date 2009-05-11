#Daemonize the player (with some specific commandline option?)
module Rmpd
  class Daemon
    require 'daemons'
    cattr_accessor :daemon

    Rmpd.config.daemon.add_option :daemonize, :type => :boolean,
      :default => false do |commandline|
      commandline.uses_switch('-d', '--daemonize', 'Daemonize process')
    end
    
    def self.boot
      Rmpd.log.info "Running plugin daemon"

      if Rmpd.config.daemon.daemonize
        self.boot_with_daemonize
      end
    end
  
    #method_chain?
    def self.boot_with_daemonize
      options = {
        :backtrace  => true,
        :monitor    => true,
        :ontop      => true,
        :multiple   => false
      }

      #werkt nog niet omdat drb voor daemon wordt geladen :(
      # Iets maken met prioritering
      Daemons.daemonize(options)
      #self.daemon = Daemons.call(options) do
      #  Rmpd::Server.run_without_callbacks
      #end
    end
  
    Rmpd::Server.metaclass.after_boot 'Rmpd::Daemon.boot'
    
  end
end