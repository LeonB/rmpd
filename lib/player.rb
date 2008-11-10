#TODO implement tagging
#TODO: make playlist seperate class
#TODO: the protocol stuff (file:// etc) should be the responsibility of the 
#I want this class to be the frontend, all public function should be here...

class Player
  attr_accessor :current_track, :history, :playlist, :current_track, :backend
  ACCEPTED_EXTENSIONS = ['.mp3', '.ogg', '.wav', 'm3u']
  
  def initialize
    self.boot
  end
  
  def boot
    self.backend = PlayerBackend.new(self)
    backend_functions :state, :playing?, :paused?, :stopped?, :pause, 
      :volume, :volume=
  end
  
  def status
    case self.state.to_s
    when 'READY'
      'waiting...'
    when 'PLAYING'
      "playing #{self.current_track.path}"
    when 'PAUSED'
      'paused'
    else 
      raise "Unknow status: #{self.state}"
    end
  end
  
  def play    
    #if still playing, return nothing
    return nil if playing?
    return self.backend.resume if paused?
    return nil if self.playlist.empty? && !self.current_track
    
    #Make sure current_track is set, if it's empty and playlist is not empty
    self.next_track_as_current unless self.playlist.empty? or self.current_track

    Rmpd.log.debug "Playing file://#{self.current_track.path}"
    self.backend.play("file://#{self.current_track.path}") #Current track is set
  end
  
  def stop
    #Remove the first track, if it's the current track 
    #(I wouldn't know when that's not. Just silly security)
    playlist.shift if playlist.first == self.current_track
    self.current_track = nil

    Rmpd.log.debug "Asking backend to stop"
    self.backend.stop
  end

  def add_array(array)
    array.each do |input|
      self.add(input)
    end
  end
  
  def add(input)
    #TODO: what if it's not a file or directory?

    if input.is_a? Array
      input.each do |value|
        add(value)
      end
      return
    end

    #I'm using Dir[] because it handles regex'es automatically
    Dir[input].each do |input|
      if File.directory?(input)
        add_dir input
      elsif File.file?(input)
        add_file(input)
      else
        raise 'Not an existing file or directory!'
      end
    end
    
    #raise "Don't know what this is!"
  end
  
  def next
    self.remove_current_track
    
    if playlist.empty?
      Rmpd.log.debug 'Playlist is empty'
    end

    if not playlist.empty?
      self.stop if self.playing? #if it isn't stopped, it is still playing and if you then press
        #play: play, play = do nothing
      self.next_track_as_current
      self.play
    else
      self.stop
    end
  end
  
  def previous
    #TODO: implement previous/history
  end
  
  def playlist
    return @playlist ||= []
  end
  
  def history
    @history ||= []
  end
  
  def next_track?
    if self.current_track
      playlist[1]
    else
      playlist[0]
    end
  end
  
  def previous_track?
    raise 'Implement previous_track?!'
  end
  
  def end_of_track_reached
    Rmpd.log.debug 'End of track reached'

    history << playlist.shift
    self.current_track = nil

    if not self.playlist.empty?
      keep_playing
    else
      stop
    end
  end

  protected
  def next_track_as_current
    self.current_track = self.next_track?
  end
  
  def keep_playing
    self.next()
  end
  
  def remove_current_track
    unless current_track.nil?
      self.current_track = nil
      self.playlist.shift
    end
  end
  
  private
  def add_file(file)
    file = File.new(file)
    
    if file.extension == 'm3u'
      add_playlist(file)
    elsif ACCEPTED_EXTENSIONS.include? file.extension
      playlist << file
    else
      raise "Not a valid extension #{file.extension}"
      #TODO: vervangen door een loging iets
    end
  end
  
  def add_dir(dir)
    Dir.new(dir).each do |file_or_dir|
      next if file_or_dir == '.' || file_or_dir == '..'
      self.add dir + '/' + file_or_dir
    end
  end
  
  def add_playlist
    
  end
  
  def backend_functions(*methods)
    methods.each do |method|
      
      meta_eval do
        define_method method do |*args|
          self.backend.send(method, *args)
        end
      end
    end
  end
  
  #include Callbacks
  #add_callback_methods :boot, :play
end #player