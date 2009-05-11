require 'rubygems'
require 'daemons'

options = {
  :backtrace  => true,
  :monitor    => true,
  :ontop      => false
}

Daemons.call(options) do
  loop do
    p 'asad'
  end
end
