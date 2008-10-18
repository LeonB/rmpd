#All you have to do (Ubuntu 8.04) is: sudo gem install libgstreamer0.10-ruby

require 'gst0.10'
#https://trac.luon.net/ruby-gstreamer0.10/

module PlayerBackend::Gstreamer
  
  def self.extended(player)
    attr_accessor :playbin
    
    Gst.init
    # setup the playbin
    player.playbin = Gst::ElementFactory.make('playbin')
  end
  
  def setup_callbacks
    #self.player.after_end_of_track()
    playbin.bus.add_watch do | message |
      case message.get_type
      when Gst::Message::MessageType::ERROR then
        print "An error occured: #{message.parse_error[0]}\n"
        #mainloop.quit
      when Gst::Message::MessageType::EOS then
        self.player.after_end_of_track()
      else
        #nothing...
      end
    end
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
    when 'null', 'ready', 'void-pending'
      State::STOPPED
    when 'playing'
      State::PLAYING
    when 'paused'
      State::PAUSED
    else
      raise "#{self.playbin.get_state.last.nick}\n"
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