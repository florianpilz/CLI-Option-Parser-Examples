require 'optparse'
require 'lib/timetabling'

options = {}
# default values
options[:severity] = 4
options[:mutation] = "DumbSwappingMutation"
options[:recombination] = "IdentityRecombination"
options[:iterations] = 5_000_000
options[:time_limit] = 0
options[:cycles] = 1

parser = OptionParser.new do |opts|
  opts.banner = "Usage: optparse-example.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
  opts.on("-s", "--severity 4", %w(4 5 6 7 8), Integer, "Severity of the timetabling problem") {|s| options[:severity] = s}
  opts.on("-m", "--mutation DumbSwappingMutation", String, "Mutation used in the algorithm", "See lib/mutations.rb for possible mutations") {|m| options[:mutation] = m}
  opts.on("-r", "--recombination IdentityRecombination", String, "Recombination used in the algorithm", "See lib/recombinations.rb for possible recombinations") {|r| options[:recombination] = r}
  opts.on("-i", "--iterations 5_000_000", Integer, "Algorithm will stop after given amount of iterations or run indefinitely if 0") {|i| options[:iterations] = i}
  opts.on("-t", "--time-limit 0", Integer, "Algorithm will stop after given amount of time limit or run indefinitely if 0") {|t| options[:time_limit] = t}
  opts.on("-c", "--cycles 1", Integer, "Algorithm will run that many times") {|c| options[:cycles] = c}
end

parser.parse!(ARGV)

constraints = Timetabling::read_timetable_data(options[:severity])

options[:cycles].times do
  Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(options[:mutation]).new, :recombination => Kernel.const_get(options[:recombination]).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => options[:iterations], :time_limit => options[:time_limit])
end