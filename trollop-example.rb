require 'rubygems'
require 'trollop'
require 'lib/timetabling'

opts = Trollop::options do
  version "timetabling 2.1 (c) 2011 Florian Pilz"
  banner <<-EOS
Timetabling is an evolutionary algorithm to solve hard-timetabling problems.

Usage:
  ruby trollop-example.rb [options]
where [options] are:
EOS
  opt :severity, "Severity of the timetabling problem", :default => 4
  opt :mutation, "Mutation used in the algorithm, see lib/mutations.rb for options", :default => "DumbSwappingMutation"
  opt :recombination, "Recombination used in the algorithm, see lib/recombinations.rb for options", :default => "IdentityRecombination"
  opt :iterations, "Algorithm will halt after this number of iterations or run indefinitely if 0", :default => 5_000_000
  opt :time_limit, "Algorithm will halt after exection time exceded the time limit or run indefinitely if 0", :default => 0
  opt :cycles, "Determines how often the algorithm will run", :default => 1
end

Trollop::die :severity, "must be in {4,5,6,7,8}" if opts[:severity] < 4 || opts[:severity] > 8
mutation = Kernel.const_get(opts[:mutation]) rescue Trollop::die(:mutation, "invalid mutation, see lib/mutations.rb")
recombination = Kernel.const_get(opts[:recombination]) rescue Trollop::die(:recombination, "invalid recombination, see lib/recombinations.rb")

constraints = Timetabling::read_timetable_data(opts[:severity])

opts[:cycles].times do
  Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(opts[:mutation]).new, :recombination => Kernel.const_get(opts[:recombination]).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => opts[:iterations], :time_limit => opts[:time_limit])
end