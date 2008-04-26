# Copyright by Daniel Waeber, see the LICENSE file for details

require 'irb'
# Simple wrapper arround IRB
# It will create a IRB Workspace with a new main object
# and create a Irb Object with itself as workspace
#
# You can start the irb-prompt and set, push or pop main object afterwords
begin
    require 'irb/completion'
rescue LoadError
    puts "!! can't lod irb/completion, so you won't have completion"
end


class IRB::Prompt < IRB::WorkSpace
    def initialize(main, opts=Hash.new)
        super(main)

        IRB.setup(nil)
        @stack  = Array.new
        @prompt = IRB::Irb.new(self)
        @context = @prompt.context
        config(opts)
    end
    def config(opts)
        opts.each_pair do |k,v|
            @context.send((k.to_s+'=').to_sym, v)
        end
    end
    def [] sym
        @context.send(sym)
    end
    def push(obj)
        @stack.push @main
        set(obj)
    end
    def pop
        set(@stack.pop())
    end
    def set(obj)
        @binding = obj.send(:eval, "binding")
        @main = obj
    end
    attr_reader  :prompt, :context
    alias :get   :main
    alias :main= :set
    def start(opts=Hash.new)
        IRB.conf[:MAIN_CONTEXT] = @context
        trap 'INT' do
            @prompt.signal_handle()
            exit 130    # exit on unhandled 
        end
        catch :IRB_EXIT do
            @prompt.eval_input()
            puts
        end
    end
end
