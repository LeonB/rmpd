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
    
  end
  
  def stop
    
  end
  
  def pause
    
  end
  
  #??
  def state
    
  end
  
  def volume
    
  end
  
  def volume=(volume)
    
  end
  
  private
  def setup_callbacks
    self.playbin.bus.connect(Gst::MessageType::EOS) do |message|
      self.player.callback_eos()
    end
  end
end