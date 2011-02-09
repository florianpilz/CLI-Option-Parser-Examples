require 'rubygems'
require 'lib/Switches' # wrapper for OptionParser
require 'lib/timetabling'

options = Switches.new do |s|
  s.banner = "Usage: switches-example.rb [options]"
  s.set!(:s, :severity, :default => 4, :type => Integer) {"Severity of the timetabling problem"}
  s.set!(:m, :mutation, :default => "DumbSwappingMutation") {"Mutation used in the evolutionary algorithm, see lib/mutations.rb for details"}
  s.set!(:r, :recombination, :default => "IdentityRecombination") {"Recombination used in the evolutionary algorithm, see lib/recombinations.rb for details"}
  s.set!(:i, :iterations, :default => 5_000_000, :type => Integer) {"Algorithm will stop after given amount of iterations or run indefinitely if 0"}
  s.set!(:t, :time_limit, :default => 0, :type => Integer) {"Algorithm will stop after given time limit or run indefinitely if 0"}
  s.set!(:c, :cycles, :default => 1, :type => Integer) {"Algorithm will run that many times"}
end

constraints = Timetabling::read_timetable_data(options.severity)

options.cycles.times do
  Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(options.mutation).new, :recombination => Kernel.const_get(options.recombination).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => options.iterations, :time_limit => options.time_limit)
end