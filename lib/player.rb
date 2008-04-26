#TODO implement tagging

class Player
  attr_accessor :current_track, :history, :playlist, :current_track
  ACCEPTED_EXTENSIONS = ['.mp3', '.ogg', '.wav', 'm3u']
  
  def initialize()
  end
  
  def status
    case state.to_s
    when 'NULL' || 'READY'
      'waiting...'
    when 'PLAYING'
      "playing #{self.current_track.path}"
    when 'PAUSED'
      'paused'
    end
  end
  
  def play
    #if still playing, return nothing
    return nil if playing?
    return nil if self.playlist.empty? && !self.current_track
    
    #Make sure current_track is set, if it's empty and playlist is not empty
    self.next_track_as_current unless self.playlist.empty? || self.current_track
    
    self.play_current_track #Current track is set
  end
  
  def pause
    self.playbin.pause
  end
  
  def stop
    #Remove the first track, if it's the current track (I wouldn't know when that's not. Just silly security)
    playlist.shift if playlist.first == self.current_track
    self.current_track = nil
    self.playbin.stop
  end
  
  def add(input)
    
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
  end
  
  def volume(level = nil)
    if level.nil?
      self.playbin.volume
    else
      self.playbin.volume = level
    end
  end
  
  def next
    self.remove_current_track
    self.next_track_as_current
    
    self.play_current_track
  end
  
  def previous
    
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
  
  def state
    self.playbin.state.to_s
  end
  
    #Deze maken adhv .state
    def playing?
      self.playbin.playing?
    end

    def stopped?
      self.playbin.stopped?
    end

    def paused
      self.playbin.paused?
    end
  
  #private
  
  def playbin=(playbin)
    @playbin = playbin
  end
  
  def playbin
    @playbin
  end
  
  def callback_eos
    history << playlist.shift
    self.current_track = nil
    
    if not self.playlist.empty?
      keep_playing
    else
      stop
    end
  end
  
  def keep_playing
    self.next()
  end
  
  def remove_current_track
    playbin.state = Gst::State::NULL #Else it WILL fail
    self.current_track = nil
    self.playlist.shift
  end
  
  def next_track_as_current
    self.current_track = self.next_track?
  end
  
  def add_file(file)
    file = File.new(file)
    
    if file.extension == 'm3u'
      add_playlist(file)
    elsif ACCEPTED_EXTENSIONS.include? file.extension
      playlist << file
    else
      #raise "Not a valid extension #{file.extension}"
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
  
  def play_current_track
    #Play the current track
    self.playbin.play(self.current_track.path)
  end
  
end