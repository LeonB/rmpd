require 'jruby_gst'

class PlayerBackends::JrubyGst
  attr_accessor :playbin, :player
  
  def initalize(player)
    self.player = player
    
    Gst.init('cmd_player')
    self.playbin = Gst::Playbin.new('cmd_player')
    setup_callbacks
  end
  
  def play(file)
    self.playbin.play(file)
  end
  
  def stop
    self.playbin.stop
  end
  
  def pause
    self.playbin.pause
  end
  
  #??
  def state
    
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
  
  private
  def setup_callbacks
    self.playbin.bus.connect(Gst::MessageType::EOS) do |message|
      self.player.callback_eos()
    end
  end
  
  def playbin=(playbin)
    @playbin = playbin
  end
  
  def playbin
    @playbin
  end
end