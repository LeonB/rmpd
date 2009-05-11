require 'rubygems'
require 'drb'

p = DRbObject.new nil, 'druby://localhost:2222'
p.add('/home/leon/Workspaces/rmpd/test/samples/gapless/16. Beethoven.wav')
p.play