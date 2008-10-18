# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'rmpd'

task :default => 'spec:run'

PROJ.name = 'rmpd'
PROJ.authors = 'Leon Bogaert'
PROJ.email = 'leon@tim-online.nl'
PROJ.url = 'www.vanutsteen.nl'
PROJ.rubyforge_name = 'rmpd'

#PROJ.rdoc.opts << '--diagram'
PROJ.rdoc.exclude << 'bin'

PROJ.spec.opts << '--color'

# EOF
