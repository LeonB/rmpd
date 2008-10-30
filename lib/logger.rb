require 'logger'

module Rmpd

  def self.log
    return @logger if @logger
    @logger = Logger.new("#{Rmpd.path}/rmpd.log")
  end
end