module CmdPlayer
  PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  #require 'jruby_gst'
  load "#{PATH}/lib/metaid.rb"
  load "#{PATH}/lib/kernel.rb"
  load "#{PATH}/lib/monkeys.rb"
  load "#{PATH}/lib/prompt.rb"
  load "#{PATH}/lib/player_backend.rb"
  load "#{PATH}/lib/player.rb"
  
  #Dit moet eigenlijk in de bin komen
  @player = Player.new
  
  Player.instance_methods(false).each do |method|
    meta_eval do
      define_method method do |*args|
        @player.send(method, *args)
      end
    end
  end
  
  #OR...
#  def self.method_missing(cmd, *args)
#    @player.send(cmd, *args)
#  end
  
  def self.to_s
    @player.status
  end
end