require 'rubygems'
require 'choice'
require 'lib/timetabling'

PROGRAM_VERSION = 2.1

Choice.options do
  header ''
  header 'Specific options:'

  option :severity do
    short '-s'
    long '--severity=4'
    desc 'Severity of the hard timetabling problem, must be an integer in {4, 5, 6, 7, 8}'
    default '4'
    cast Integer
    valid %w(4 5 6 7 8)
  end

  option :mutation do
    short '-m'
    long '--mutation=DumbSwappingMutation'
    desc 'The mutation used in the evolutionary algorithm, see lib/mutations.rb for choices'
    default Kernel.const_get('TripleSwapperWithTwoCollidingConstraintsMutation')
    filter do |mutation|
      Kernel.const_get(mutation)
    end
  end
  
  option :recombination do
    short '-r'
    long '--recombination=IdentityRecombination'
    desc 'The recombination used in the evolutionary algorithm, see lib/recombinations.rb for choices'
    default Kernel.const_get('IdentityRecombination')
    filter do |recombination|
      Kernel.const_get(recombination)
    end
  end
  
  option :iterations do
    short '-i'
    long '--iterations=5_000_000'
    desc 'Algorithm will stop after the allowed iterations were exceded'
    default 5_000_000
    cast Integer
  end
    
  option :time_limit do
    short '-t'
    long '--time-limit=0'
    desc 'Algorithm will stop after allowed time, will run indefinitely if time limit is 0'
    default 0
    cast Integer
  end
  
  option :cycles do
    short '-c'
    long '--cycles=100'
    desc 'Determines how often the algorithm will run'
    default 1
    cast Integer
  end

  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end

  option :version do
    short '-v'
    long '--version'
    desc 'Show version'
    action do
      puts "timetabling v#{PROGRAM_VERSION}"
      exit
    end
  end
end

constraints = Timetabling::read_timetable_data(Choice.choices[:severity])

Choice.choices[:cycles].times do
  Timetabling::run(:constraints => constraints, :mutation => Choice.choices[:mutation].new, :recombination => Choice.choices[:recombination].new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => Choice.choices[:iterations], :time_limit => Choice.choices[:time_limit])
end