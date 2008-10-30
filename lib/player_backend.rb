#TODO: define an interface
class PlayerBackend
  attr_accessor :player
  attr_reader :state
  
  def initialize(player)
    self.player = player
    @state = State::READY
    
    if defined? JRUBY_VERSION
      require 'lib/player_backends/jruby_gst.rb'
      self.class.send(:include, PlayerBackend::JrubyGst)
    else
      require 'lib/player_backends/gst.rb'
      self.class.send(:include, PlayerBackend::Gst)
    end
    
    super()
  end
  
  def play(*args)
    @state = State::PLAYING
    #Don't use join, because the code will wait until the thread has finished

    Thread.new do #make this optional
      Thread.abort_on_exception = true

      #I don't like this part, but this gets sometimes fired from another thread
      #And then I have to kill that _hard_
      #I've somebody knows how to fix this: PLEASE, PLEASE, PLEASE let me know
      @thread.exit if @thread
      @thread = Thread.current

      @loop = GLib::MainLoop.new(nil, false)
      super
      @loop.run
    end
  end
  
  def stop
    @state = State::READY
    super
    @loop.quit
  end
  
  def playing?
    self.state == State::PLAYING
  end
  
  def ready?
    self.state == State::READY
  end
  
  def paused?
    self.state == State::PAUSED
  end
end