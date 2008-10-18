#require 'jruby_gst'
require '/home/leon/Workspaces/jruby_gst/lib/jruby_gst.rb'

module PlayerBackend::JrubyGst
  
  def self.extended(base)
    attr_accessor :playbin
    
    Gst.init('cmd_player')
    base.playbin = Gst::Playbin.new('cmd_player')
  end
  
  def play(uri)
    playbin.state = Gst::State::NULL #Else it WILL fail
    self.playbin.uri = uri
    self.playbin.play
  end
  
  def stop
    self.playbin.stop
  end
  
  def pause
    self.playbin.pause
  end
  
  def state
    self.playbin.state
  end
  
  def volume
    
  end
  
  def volume(level = nil)
    if level.nil?
      self.playbin.volume
    else
      self.playbin.volume = level
    end
  end
  
  def setup_callbacks
    self.playbin.bus.connect(Gst::MessageType::EOS) do |message|
      self.player.after_end_of_track()
    end
  end
 
  def playbin=(playbin)
    @playbin = playbin
  end
  
  def playbin
    @playbin
  end
end