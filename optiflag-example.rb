require 'rubygems'
require 'optiflag'
require 'lib/timetabling'

module OptionParser extend OptiFlagSet
  optional_flag "severity" do
    description "Severity of the timetabling problem"
    default "4"
    value_in_set %w(4 5 6 7 8)
  end
  
  optional_flag "mutation" do
    description "Mutation used in the evolutionary algorithm, see lib/mutations.rb for details"
    default "DumbSwappingMutation"
    value_in_set %w(DumbSwappingMutation CollidingConstraintsSwapperMutation InvertingMutation InvertingWithCollisionMutation MixingMutation ShiftingMutation SwappingWithCollidingPeriodMutation SwappingWithCollidingConstraintMutation DumbTripleSwapperMutation TripleSwapperWithTwoCollidingPeriodsMutation TripleSwapperWithTwoCollidingConstraintsMutation IdentityMutation)
  end
  
  optional_flag "recombination" do
    description "Recombination used in the evolutionary algorithm, see lib/recombinations.rb for details"
    default "IdentityRecombination"
    value_in_set %w(OrderingRecombination MappingRecombination MinEdgesEdgeRecombination MinCollisionsWithLastConstraintEdgeRecombination MinCollisionsEdgeRecombination IdentityRecombination)
  end
  
  optional_flag "iterations" do
    description "Algorithm will stop after given amount of iterations or run indefinitely if 0"
    default "5_000_000"
    validates_against {|flag, errors| errors << "iterations must be a non-negative Integer" unless flag.value.to_i >= 0}
  end
  
  optional_flag "time_limit" do
    description "Algorithm will stop after given time limit or run indefinitely if 0"
    default "0"
    validates_against {|flag, errors| errors << "time limit must be a non-negative Integer" unless flag.value.to_i >= 0}
  end
  
  optional_flag "cycles" do
    description "Algorithm will run that many times"
    default "1"
    validates_against {|flag, errors| errors << "cycles must be a Integer greater or equal to 1" unless flag.value.to_i > 0}
  end
  
  and_process!
end

options = OptionParser.flags # or ARGV.flags

constraints = Timetabling::read_timetable_data(options.severity)

options.cycles.to_i.times do
  Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(options.mutation).new, :recombination => Kernel.const_get(options.recombination).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => options.iterations.to_i, :time_limit => options.time_limit.to_i)
end