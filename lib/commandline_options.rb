module Rmpd
  module CommandlineOptions extend OptiFlagSet
  
    def parse
      and_process!
    end
    
  end #CommandlineOptions
end #Rmpd