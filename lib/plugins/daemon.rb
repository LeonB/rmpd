#Daemonize the player (with some specific commandline option?)

class Player
  def status_message
    print "#{self.status}\n"
  end
  
  #method_chain?
  def play_with_daemonize
    loop do
      play_without_daemonize
      sleep 1
    end
  end
  
  #before_play 'Thread.new do'
  #after_play 'end'
  after_boot :status_message
end