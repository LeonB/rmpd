#!/usr/bin/env ruby

require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'lib', 'rmpd'))

#Start the player
player = Player.new
player.add('/usr/share/emesene/sound_themes/default/send.wav')
player.add('/usr/share/nero/sounds/DingDong.wav')
player.add('/usr/share/emesene/sound_themes/default/send.wav')
player.add('/usr/share/nero/sounds/DingDong.wav')
player.add('/usr/share/nero/sounds/DingDong.wav')
player.add('/usr/share/nero/sounds/DingDong.wav')
player.add('/home/leon/Music/Uit te zoeken/Johnny Cash - Walk The Line (The Very Best Of)-3CD-2006-SMO seed by www.p2p-world.dl.am/101-johnny_cash_-_walk_the_line.mp3')
player.add('/home/leon/Music/Uit te zoeken/Johnny Cash - Walk The Line (The Very Best Of)-3CD-2006-SMO seed by www.p2p-world.dl.am/104-johnny_cash_-_jackson.mp3')
#player.add('http://s3.amazonaws.com/pillowfactory/org/AintGotNoRSpec-Ringtone.mp3')
#player.volume(3.0)
player.play

#loop do
begin
  while player.playing? do
    #p player.playlist
    #Rmpd.log.info "playing #{player.current_track.path}"
    sleep 1
  end
ensure
  player.stop
end
