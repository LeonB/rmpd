#All you have to do (Ubuntu 8.04) is: sudo gem install libgstreamer0.10-ruby

require 'gst0.10'

module PlayerBackend::Gstreamer
  
  def self.extended(base)
    attr_accessor :playbin
    
    Gst.init
    # setup the playbin
    base.playbin = Gst::ElementFactory.make('playbin')
  end
  
  def setup_callbacks
    
  end
  
  def play(uri)    
    self.playbin.uri = uri
    self.playbin.ready
    self.playbin.play
  end
  
  def resume
    self.playbin.play
  end
  
  def stop
    self.playbin.stop
  end
  
  def pause
    self.playbin.pause
  end
  
  def state
    case self.playbin.get_state.last.nick
    when 'null', 'ready'
      State::STOPPED
    when 'playing'
      State::PLAYING
    when 'paused'
      State::PAUSED
    else
      print "#{self.playbin.get_state.last.nick}\n"
      exit
    end
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
  
end