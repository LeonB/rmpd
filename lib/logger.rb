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

  Rmpd.config.add_option(:log_level, :type => ['debug', 'info', 'warn'],
    :default => 'warn') do |commandline|
    commandline.uses_option('-l', '--log-level LEVEL', 'Log level to use')
  end
  Rmpd.config.build

  def self.log
    if not @logger
      @logger = Logging.logger("#{Rmpd.path}/rmpd.log")
      @logger.level = Rmpd.config.log_level.to_sym
    end
    @logger
  end
end
