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
    playbin.uri = uri
    setup_callbacks

    playbin.play
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
    self.playbin.volume
  end
  
  def volume=(level)
    self.playbin.volume = level
  end
  
  def state=(states)
    state = states[1]
    
    case state.nick
    when 'ready', 'void-pending'
      new_state = State::READY
    when 'playing'
      new_state = State::PLAYING
    when 'paused'
      new_state = State::PAUSED
    end

    if @state != new_state
      @state = new_state
      Rmpd.log.debug "Changed state to: #{new_state}"
    end
  end
  
  protected
  def setup_callbacks
    playbin.bus.add_watch do |bus, message|
      case message.type
      when Gst::Message::EOS
        Rmpd.log.debug 'GST: EOS call received'
        self.stop
        self.player.end_of_track_reached()
      when Gst::Message::ERROR
        Rmpd.log.warn(message.parse)
        self.player.stop
      when Gst::Message::STATE_CHANGED
        self.state = playbin.get_state(200 * Gst::MSECOND)
      when Gst::Message::TAG
        Rmpd.log.debug "Tag discovered"
      else
        Rmpd.log.debug message.type
        Rmpd.log.debug message.to_s
        Rmpd.log.debug message.inspect
      end
      true #If you remove this, the watch doesn't end
    end
  end
  
end
