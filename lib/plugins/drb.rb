#Use drb for (local) access to the runing daemon (unix sockets)
# * http://www.ruby-doc.org/stdlib/libdoc/drb/rdoc/index.html
# * http://kasparov.skife.org/blog/2006/04/22/

module Rmpd
  class Drb
    require 'drb'
    cattr_accessor :service

    Rmpd.config.drb.add_option :host, :default => 'localhost' do |commandline|
      commandline.uses_option('--drb-host HOST', 'Drb host')
    end
    Rmpd.config.drb.add_option :port, :default => 7777, :type => :integer do |commandline|
      commandline.uses_option('--drb-port PORT', 'Drb port')
    end
    
    def self.start_drb_service
      Rmpd.log.info "Running plugin drb"

      host = Rmpd.config.drb.host
      port = Rmpd.config.drb.port
      
      Rmpd::Drb.service = DRb.start_service("druby://#{host}:#{port}", Rmpd::Server.player)
    end
    
    def self.stop_drb_service
      DRb.stop_service
    end
    
    Rmpd::Server.metaclass.before_boot 'Rmpd::Drb.start_drb_service'
    Rmpd::Server.metaclass.before_exit 'Rmpd::Drb.stop_drb_service' #this is ensured!
  end
end