#!/usr/bin/env ruby

require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'lib', 'rmpd'))

#Start the player
player = Player.new
files = Dir['/home/leon/Workspaces/rmpd/test/samples/gapless/*.wav'].sort
player.add(files)
player.play

#loop do
begin
  while player.playing? do
    #p player.playlist
    p "playing #{player.current_track.path}"
    sleep 1
  end
ensure
  player.stop
end
