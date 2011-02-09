require 'rubygems'
require 'Getopt/Declare'
require 'lib/timetabling'

args = Getopt::Declare.new(<<'EOF')

-s, --severity <num:i>        severity of the timetabling problem
-m, --mutation <str:s>        mutation used in algorithm, see lib/mutations.rb for options
-r, --recombination <str:qs>   recombination used in algorithm, see lib/recombinations.rb for options
-i, --iterations <num:i>      algorithm will stop after given iterations or run indefinitely if 0
-t, --time-limit <num:i>      algorithm will stop after given time limit or run indefinitely if 0
-c, --cycles <num:i>          algorithm will run that many times
EOF

constraints = Timetabling::read_timetable_data(args['-s'])

args['-c'].times do
  Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(args['-m']).new, :recombination => Kernel.const_get(args['-r']).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => args['-i'], :time_limit => args['-t'])
end