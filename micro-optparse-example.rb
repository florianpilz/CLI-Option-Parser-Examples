require 'rubygems'
require 'micro-optparse'
require 'lib/timetabling'

opts = Parser.new do |p|
  p.version = "timetabling 2.1 (c) 2011 Florian Pilz"
  p.banner = "Timetabling is an evolutionary algorithm to solve hard-timetabling problems."
  p.option :severity, "Severity of the timetabling problem", :default => 4, :value_in_set => [4,5,6,7,8]
  p.option :mutation, "Mutation used in the algorithm, see lib/mutations.rb for options", :default => "DumbSwappingMutation"
  p.option :recombination, "Recombination used in the algorithm, see lib/recombinations.rb for options", :default => "IdentityRecombination"
  p.option :iterations, "Algorithm will halt after this number of iterations or run indefinitely if 0", :default => 5_000_000
  p.option :time_limit, "Algorithm will halt after exection time exceded the time limit or run indefinitely if 0", :default => 0
  p.option :cycles, "Determines how often the algorithm will run", :default => 1
end.process!

mutation = Kernel.const_get(opts[:mutation]) rescue raise(ArgumentError.new("invalid mutation, see lib/mutations.rb"))
recombination = Kernel.const_get(opts[:recombination]) rescue raise(ArgumentError.new("invalid recombination, see lib/recombinations.rb"))

constraints = Timetabling::read_timetable_data(opts[:severity])

opts[:cycles].times do
  Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(opts[:mutation]).new, :recombination => Kernel.const_get(opts[:recombination]).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => opts[:iterations], :time_limit => opts[:time_limit])
end