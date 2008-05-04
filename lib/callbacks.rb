#Stolen from rails/activerecord

require 'observer'
module Callbacks
  CALLBACKS = %w(
      when_song_halfway at_song_end after_boot before_shutdown
  )

  def self.included(base) #:nodoc:
    base.extend Observable

    CALLBACKS.each do |method|
      base.class_eval <<-"end_eval"
          def self.#{method}(*callbacks, &block)
            callbacks << block if block_given?
            write_inheritable_array(#{method.to_sym.inspect}, callbacks)
          end
      end_eval
    end
  end
  
  private
  def callback(method)
    notify(method)

    callbacks_for(method).each do |callback|
      result = case callback
      when Symbol
        self.send(callback)
      when String
        eval(callback, binding)
      when Proc, Method
        callback.call(self)
      else
        if callback.respond_to?(method)
          callback.send(method, self)
        else
          raise "Callbacks must be a symbol denoting the method to call, a string to be evaluated, a block to be invoked, or an object responding to the callback method."
        end
      end
      return false if result == false
    end

    result = send(method) if respond_to?(method)

    return result
  end

  def callbacks_for(method)
    self.class.read_inheritable_attribute(method.to_sym) or []
  end

  def invoke_and_notify(method)
    notify(method)
    send(method) if respond_to?(method)
  end

  def notify(method) #:nodoc:
    self.class.changed
    self.class.notify_observers(method, self)
  end
end