#All you have to do (Ubuntu 8.04) is: sudo gem install libgst-ruby

require 'gst'
#http://ruby-gnome2.sourceforge.jp
#http://www.cozmixng.org/retro/projects/ruby-gnome2/browse/ruby-gnome2/trunk/gstreamer

module PlayerBackend::Gst
  
  def self.included(player)
    attr_accessor :playbin
  end
  
  def initialize
    # setup the playbin
    self.playbin = Gst::ElementFactory.make('playbin')
  end
  
  def play(uri)
    self.playbin.uri = uri
    self.setup_callbacks
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
  
  def volume
    
  end
  
  def volume(level = nil)
    if level.nil?
      self.playbin.volume
    else
      self.playbin.volume = level
    end
  end
  
  def state=(states)
    state = states[1]
    
    case state.nick
    when 'ready', 'void-pending'
      @state = State::READY
    when 'playing'
      @state = State::PLAYING
    when 'paused'
      @state = State::PAUSED
    end
  end
  
  protected
  def setup_callbacks
    #self.player.after_end_of_track()
    playbin.bus.add_watch do |bus, message|
      case message.type
      when Gst::Message::EOS
        self.player.end_of_track_reached()
      when Gst::Message::ERROR
        p message.parse
        self.player.end_of_track_reached()
      when Gst::Message::STATE_CHANGED
        self.state = playbin.get_state
      else
        #p message.type
      end
      true #If you remove this, the watch doesn't end
    end
  end
  
end
