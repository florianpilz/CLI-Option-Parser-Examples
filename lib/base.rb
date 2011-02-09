# Copyright (c) 2011 Florian Pilz
# See MIT-LICENSE for license information.

class Array
  def sum
    inject( nil ) { |sum,x| sum ? sum+x : x }
  end
  
  def mean
    sum / size.to_f
  end
  
  def rand_index
    rand(self.length)
  end
  
  def sample
    self[rand_index]
  end
  
  def to_periods(slots)
    slot_size = self.length / slots
    periods = []
    
    slots.times do |slot|
      period_constraints = []
      
      slot_size.times do |i|
        period_constraints << self[slot * slot_size + i]
      end
      periods << Period.new(period_constraints)
    end
    
    periods
  end
  
  def to_constraints
    constraints = []
    self.each do |period|
      constraints += period.constraints
    end
    constraints
  end
end

class Constraint
  attr_accessor :klass, :teacher, :room
  
  def initialize(values = {})
    @klass = values[:klass]
    @teacher = values[:teacher]
    @room = values[:room]
  end
  
  def to_s
    "Klasse: #{@klass}, Lehrer: #{@teacher}, Raum: #{@room}"
  end
  
  def self.parse(string)
    klass, teacher, room = string.scan(/C(\d).*S\d.*T(\d).*R(\d).*/).first.map!{ |number_as_string| number_as_string.to_i }
    Constraint.new(:klass => klass, :teacher => teacher, :room => room)
  end
end

class Period
  attr_accessor :constraints
  
  def initialize(constraints)
    @constraints = constraints
  end
  
  def collision?
    @constraints.each do |c1|
      @constraints.each do |c2|
        next if c1 == c2
        return true if c1.klass == c2.klass || c1.teacher == c2.teacher || c1.room == c2.room
      end
    end
    false
  end
  
  def rand_colliding_constraint_index
    colliding_constraints = []
    @constraints.each do |c1|
      @constraints.each do |c2|
        next if c1 == c2
        if c1.klass == c2.klass || c1.teacher == c2.teacher || c1.room == c2.room
          colliding_constraints << c1
          colliding_constraints << c2
        end
      end
    end
    @constraints.index(colliding_constraints.uniq.sample) or raise(ScriptError, "no colliding constraints present")
  end
  
  def rand_constraint_index
    @constraints.rand_index
  end
end

class Individual
  attr_accessor :constraints, :collisions, :unfulfilled_constraints, :number_of_slots
  
  def initialize(values = {})
    values = {:granularity => 0, :debug => false}.merge(values)
    @constraints          = values[:current_constraints]
    @expected_constraints = values[:expected_constraints]
    @mutation             = values[:mutation]
    @recombination        = values[:recombination]
    @granularity          = values[:granularity]
    @debug                = values[:debug]
    @number_of_slots      = values[:number_of_slots]
    @slot_size            = @constraints.length / @number_of_slots
    self.eval_fitness
  end
  
  def to_s
    "Individual with #{@mutation.to_s} and #{@recombination.to_s}"
  end
  
  def copy
    individual = self.clone
    individual.constraints = @constraints.clone # only attribute that may change
    individual
  end
  
  def mutate # must return 1 new individual
    @mutation.call(self)
  end
  
  def recombinate_with(individual) # must return 1 new individual
    @recombination.call(self, individual)
  end
  
  def fitness
    @collisions + @unfulfilled_constraints
  end
  
  def eval_fitness
    @collisions = eval_collisions
    @unfulfilled_constraints = eval_unfulfilled_constraints
    fitness
  end
  
  def distance_to(other)
    differing_constraints = 0
    @constraints.each_index do |i|
      differing_constraints += 1 unless @constraints[i] == other.constraints[i]
    end
    differing_constraints / @constraints.length.to_f
  end
  
  private
  
  def eval_collisions
    collisions = 0
    @number_of_slots.times do |n|
      old_collisions = collisions
      
      0.upto(@slot_size - 1) do |i|
        c1 = @constraints[@slot_size * n + i]
        
        (i + 1).upto(@slot_size - 1) do |j|
          c2 = @constraints[@slot_size * n + j]

          if @granularity == 0
            collisions += 1 if c1.klass == c2.klass
            collisions += 1 if c1.teacher == c2.teacher
            collisions += 1 if c1.room == c2.room
          elsif @granularity == 1
            collisions += 1 if c1.klass == c2.klass || c1.teacher == c2.teacher || c1.room == c2.room
          else
            if old_collisions == collisions # only increase collisions once per period
              collisions += 1 if c1.klass == c2.klass || c1.teacher == c2.teacher || c1.room == c2.room
            end
          end
        end
      end
    end
    collisions
  end
  
  def eval_unfulfilled_constraints
    return 0 unless @debug # assume all constraints are fulfilled unless in debug mode
    
    expected_constraints = @expected_constraints.clone
    delete_constraints = []
    
    expected_constraints.each do |c1|
      constraints.each do |c2|
        delete_constraints << c1 if c1 == c2
      end
    end
    
    delete_constraints.each do |c|
      expected_constraints.delete(c)
    end
    
    expected_constraints.length
  end
end