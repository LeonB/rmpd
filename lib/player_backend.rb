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
      super
      begin
        self.loop.run
      rescue Interrupt
      ensure
        Thread.exit #this needs to go before stop?
        stop
      end
    end
    
  end
  
  def stop
    @state = State::READY
    super
    loop.quit
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
  
  protected
  def loop
    @loop ||= GLib::MainLoop.new(nil, false)
  end
  
end