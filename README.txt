cmd_player
    by Leon Bogaert
    http://www.vanutsteen.nl
    http://lorenzod8n.wordpress.com/2008/04/05/an-mpd-clone-in-ruby/

== DESCRIPTION:

A Ruby MPD clone. 

== FEATURES/PROBLEMS:

* FIXME (list of features or problems)

== SYNOPSIS:

  FIXME (code sample of usage)

== REQUIREMENTS:

* ruby-gstreamer by Sjoerd Simons OR the jruby_gst gem
* Gstreamer >= 0.10

== INSTALL:

* sudo gem install rmpd

== TODO:

* Split up the player in jruby_gst & ruby-gst
  * play, pause, stop, state + callbacks?
  * Mhzzz...
* Modularize _everything_
  * commandline arguments in every module
  * Player
  * Daemon
  * XML-RPC
  * Input souces?
  * ...
* Make a directory "interfaces" for xml/rpc, drb etc.

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIXME (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
