#require 'logger'
##http://logging.rubyforge.org??
#
#module Rmpd
#
#  def self.log
#    return @logger if @logger
#    @logger = Logger.new("#{Rmpd.path}/rmpd.log")
#  end
#end

require 'logging'

module Rmpd

  def self.log
    return @logger if @logger
    @logger = Logging.logger("#{Rmpd.path}/rmpd.log")
  end
end
