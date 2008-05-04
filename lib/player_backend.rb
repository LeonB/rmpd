class PlayerBackend
  attr_accessor :player 
  
  def initialize(player)
    self.player = player
    
    if defined? JRUBY_VERSION
      require 'lib/player_backends/jruby_gst.rb'
      extend PlayerBackend::JrubyGst
    else
      require 'lib/player_backends/gstreamer.rb'
      extend PlayerBackend::Gstreamer
    end
    
    self.setup_callbacks
  end
  
  def playing?
    self.state == State::PLAYING
  end
  
  def stopped?
    self.state == State::STOPPED
  end
  
  def paused?
    self.state == State::PAUSED
  end
end