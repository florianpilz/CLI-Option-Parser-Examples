# Copyright (c) 2011 Florian Pilz
# See MIT-LICENSE for license information.

require 'base'
require 'mutations'
require 'recombinations'

# offene Fragen:
# - Beweis, dass Menge von clashing_periods durch gegenseitigen Austausch nicht zwingend zur Lösung führt
# - Beweis, dass nur Austausch der Constraints die clashing hervorrufen genügt
# - Beweis, dass Austausch von Constraints zwischen clashing_periods und nonclashing_periods genügt
# - zurücktauschen bei brute force wichtig?

module Main
  @print_info = false
  
  def self.print_info=(bool)
    @print_info = bool
  end
  
  def self.run(values)
    individuals = []
    values[:population_size].times do
      individuals << Individual.new(
        values.merge({:current_constraints => values[:constraints].shuffle,
                      :expected_constraints => values[:constraints]}))
    end
    
    time = Time.now
    iterations = 0
    individuals = individuals.sort_by(&:fitness)
    puts "=== Start with population size of #{values[:population_size]}\n=== Mutation: #{values[:mutation]}\n=== Recombination: #{values[:recombination]}\n"
    
    while individuals.first.fitness > 0 && (values[:time_limit] == 0 || values[:time_limit] > Time.now - time) && (values[:iteration_limit] == 0 || values[:iteration_limit] > iterations)
      iterations += 1
      
      new_individuals = []
      values[:childs].times do
        if rand <= values[:recombination_chance]
          child = individuals.sample.recombinate_with(individuals.sample)
          if rand <= values[:mutation_chance]
            child = child.mutate
          end
          new_individuals << child
        else
          new_individuals << individuals.sample.mutate
        end
      end
      
      sorted_individuals = (new_individuals + individuals).sort_by(&:fitness).take(values[:population_size])
      if sorted_individuals.first.fitness < individuals.first.fitness || @print_info
        @print_info = false
        Main::print_status(iterations, sorted_individuals, time)
      end
      individuals = sorted_individuals
    end
    
    if individuals.first.fitness > 0
      Main::print_status(iterations, individuals, time)
      puts "=== unfinished"
    else
      puts "=== finished"
    end
  end
  
  def self.print_status(iterations, individuals, time)
    diversity_array = []
    individuals.each do |individual1|
      individuals.each do |individual2|
        diversity_array << individual1.distance_to(individual2)
      end
    end
    diversity = diversity_array.mean
    
    puts "Iterations: #{iterations}, Collisions: #{individuals.first.fitness}, Time: #{Time.now - time}, Diversity: #{diversity}"
  end

  def self.read_timetable_data(number)
    constraints = []
    File.open("hard-timetabling-data/hdtt#{number}list.txt", "r") do |file|
      while line = file.gets
        constraints << Constraint.parse(line)
      end
    end
    constraints
  end
end

Signal.trap("TSTP") do |x| # Control-Z
  Main::print_info = true
end

constraints = Main::read_timetable_data(timetable)

cycles.times do
  Main::run(:constraints => constraints, :mutation => mutationclass.new, :recombination => recombinationclass.new, :number_of_slots => 30, :population_size => 1, :childs => 1, :recombination_chance => 0.0, :mutation_chance => 1.0, :iteration_limit => iteration_limit, :time_limit => time_limit)
end