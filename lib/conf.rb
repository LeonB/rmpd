require 'ostruct'
class Conf < OpenStruct
  include Enumerable
  
  def members
    methods(false).grep(/=/).map { |m| m[0...-1] }
  end

  def each
    members.each do |method|
      yield send(method)
    end
    self
  end
  
  def add_hash(hash)
    hash.each_pair do |name, val|
      self.send("#{name}=", val)
    end
  end
  
end