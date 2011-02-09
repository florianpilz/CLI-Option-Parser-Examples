# Copyright (c) 2011 Florian Pilz
# See MIT-LICENSE for license information.

class Recombination
  def to_s
    self.class.to_s
  end
end

class IdentityRecombination < Recombination
  def call(individual1, individual2)
    individual1.copy
  end
end

class OrderingRecombination < Recombination
  def call(individual1, individual2)
    constraints = []
    rand_length = rand(individual1.constraints.length + 1)
    rand_length.times do |i|
      constraints << individual1.constraints[i]
    end
    
    individual2.constraints.each do |constraint|
      constraints << constraint unless constraints.include?(constraint)
    end
    
    child = individual1.copy
    child.constraints = constraints
    child.eval_fitness
    child
  end
end

class MappingRecombination < Recombination
  def call(individual1, individual2)
    constraints = []
    rn_start = individual1.constraints.rand_index
    rn_end = individual1.constraints.rand_index
    rn_start, rn_end = rn_end, rn_start if rn_start > rn_end
    
    rn_start.upto(rn_end) do |i|
      constraints[i] = individual1.constraints[i]
    end
    
    0.upto(rn_start - 1) do |i|
      c = individual2.constraints[i]
      c = individual1.constraints[individual2.constraints.index(c)] while constraints.include?(c)
      constraints[i] = c
    end
    
    (rn_end + 1).upto(individual1.constraints.length - 1) do |i|
      c = individual2.constraints[i]
      c = individual1.constraints[individual2.constraints.index(c)] while constraints.include?(c)
      constraints[i] = c
    end
    
    child = individual1.copy
    child.constraints = constraints
    child.eval_fitness
    child
  end
end

class EdgeRecombinationTemplate < Recombination
  
  private
  
  def call_template(individual1, individual2)
    constraints = []
    used_constraints = []
    length = individual1.constraints.length
    edges = Hash.new do |hash, key|
      hash[key] = Array.new # default value
    end
    
    individual1.constraints.each_with_index do |constraint, i|
      edges[constraint] << individual1.constraints[(i + 1) % length]
      edges[constraint] << individual1.constraints[(i - 1) % length]
    end
    
    individual2.constraints.each_with_index do |constraint, i|
      edges[constraint] << individual2.constraints[(i + 1) % length]
      edges[constraint] << individual2.constraints[(i - 1) % length]
    end
    
    constraints << individual1.constraints.first
    used_constraints << individual1.constraints.first
    1.upto(length - 1) do |i|
      sorted_possibilities = (edges[constraints.last] - used_constraints).sort_by{|c| yield c, edges, used_constraints, constraints}
      k = []
      sorted_possibilities.each do |c|
        break if (yield c, edges, used_constraints, constraints) > (yield sorted_possibilities.first, edges, used_constraints, constraints)
        k << c
      end
      
      if k.empty?
        constraint = (individual1.constraints - used_constraints).sample
        constraints << constraint
        used_constraints << constraint
      else
        constraint = k.sample
        constraints << constraint
        used_constraints << constraint
      end
    end
    
    child = individual1.copy
    child.constraints = constraints
    child.eval_fitness
    child
  end
  
  def calc_collisions(c1, c2) # helper for collision oriented EdgeRecombinations
    collisions = 0
    collisions += 1 if c1.klass == c2.klass
    collisions += 1 if c1.teacher == c2.teacher
    collisions += 1 if c1.room == c2.room
    collisions
  end
end

class MinEdgesEdgeRecombination < EdgeRecombinationTemplate
  def call(individual1, individual2)
    call_template(individual1, individual2) do |constraint, edges, used_constraints, _|
      (edges[constraint] - used_constraints).length
    end
  end
end

class MinCollisionsWithLastConstraintEdgeRecombination < EdgeRecombinationTemplate
  def call(individual1, individual2)
    call_template(individual1, individual2) do |constraint, _, _, current_constraints|
      calc_collisions(current_constraints.last, constraint)
    end
  end
end

class MinCollisionsEdgeRecombination < EdgeRecombinationTemplate
  def call(individual1, individual2)
    slot_size = individual1.constraints.length / individual1.number_of_slots
    call_template(individual1, individual2) do |constraint, _, _, current_constraints|
      end_index = current_constraints.length - 1
      start_index = end_index - slot_size + 1
      start_index = 0 if start_index < 0
      
      last_slot_size_constraints = current_constraints[start_index..end_index]
      last_slot_size_constraints.map{|c| calc_collisions(c, constraint)}.sum
    end
  end
end