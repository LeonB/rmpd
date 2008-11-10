#TODO: define an interface
require 'monitor'

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
    Rmpd.log.info "Playing #{args.first}"

    Rmpd.log.debug "Creating new thread"
    Thread.new do #make this optional
      Thread.abort_on_exception = true
      Thread.critical = true

      #I don't like this part, but this gets sometimes fired from another thread
      #And then I have to kill that _hard_
      #I've somebody knows how to fix this: PLEASE, PLEASE, PLEASE let me know
      #Maybe with Thread.pass? :P

      #Is this still necessary?
      #if @thread
      #  Rmpd.log.debug "Joing previous thread"
      #  @thread.join
      #end

      Rmpd.log.debug 'Setting current thread as @thread'
      @thread = Thread.current

      PlayerBackend.monitor.synchronize do
        @loop = GLib::MainLoop.new(nil, true)
        super
        Rmpd.log.debug 'Running mainloop'
        @loop.run
      end
    end
  end
  
  def stop
    super
    @loop.quit if @loop
    @state = State::READY
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

  private
  def self.monitor
    @monitor ||= Monitor.new
  end

end