require 'rubygems'
require 'thor'
require 'lib/timetabling'

class App < Thor
  desc "timetabling", "start timetabling algorithm"
  method_options :severity => 4, :mutation => "DumbSwappingMutation", :recombination => "IdentityRecombination", :iterations => 5_000_000, :time_limit => 0.0, :cycles => 1
  def timetabling()
    constraints = Timetabling::read_timetable_data(options[:severity])

    options[:cycles].times do
      Timetabling::run(:constraints => constraints, :mutation => Kernel.const_get(options[:mutation]).new, :recombination => Kernel.const_get(options[:recombination]).new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => options[:iterations], :time_limit => options[:time_limit])
    end
  end
end

App.start