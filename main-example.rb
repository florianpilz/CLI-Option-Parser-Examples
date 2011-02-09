require 'rubygems'
require 'main'
require 'lib/timetabling'

Main {
  keyword('severity'){
    cast :int
    description 'Severity of the timetabling problem'
    default 4
    validate {|i| i >= 4 && i <= 8}
  }
  
  keyword('mutation'){
    description 'Mutation used in the evolutionary algorithm, see lib/mutations.rb'
    default "DumbSwappingMutation"
    validate {|mutation| Kernel.const_get(mutation)}
  }
  
  keyword('recombination'){
    description 'Recombination used in the evolutionary algorithm, see lib/recombinations.rb'
    default "IdentityRecombination"
    validate {|recombination| Kernel.const_get(recombination)}
  }
    
  keyword('iterations'){
    cast :int
    description 'Algorihm will stop after given iterations or run indefinitely if 0'
    default 5_000_000
    validate {|i| i >= 0}
  }
  
  keyword('time limit'){
    cast :int
    description 'Algorihm will stop after given time limit or run indefinitely if 0'
    default 0.0
    validate {|i| i >= 0.0}
  }
  
  keyword('cycles'){
    cast :int
    description 'Number of times the algorithm will run'
    default 1
    validate {|i| i >= 1}
  }
  
  def run
    constraints = Timetabling::read_timetable_data(params['severity'].value)
    
    params["cycles"].value.times do
      Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(params["mutation"].value).new, :recombination => Kernel.const_get(params["recombination"].value).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => params["iterations"].value, :time_limit => params["time limit"].value)
    end
  end
}