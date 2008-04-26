class PlayerBackend
  
  def initialize
    if defined? JRUBY_VERSION
      require "#{PATH/lib/player_backends/jruby_gst.rb}"
      return PlayerBackends::JrubyGst.new
    else
      require "#{PATH/lib/player_backends/gstreamer.rb}"
      return PlayerBackends::Gstreamer.new
    end
  end
end