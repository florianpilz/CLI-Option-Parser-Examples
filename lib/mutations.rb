# Copyright (c) 2011 Florian Pilz
# See MIT-LICENSE for license information.

class Mutation
  def to_s
    self.class.to_s
  end
end

class IdentityMutation < Mutation
  def call(individual)
    individual.copy
  end
end

####################
# Swapping Mutations
####################

class DumbSwappingMutation < Mutation
  def call(individual)
    child = individual.copy
    r1 = child.constraints.rand_index
    r2 = child.constraints.rand_index

    child.constraints[r1], child.constraints[r2] = child.constraints[r2], child.constraints[r1]
    child.eval_fitness
    child
  end
end

class CollidingConstraintsSwapperMutation < Mutation
  def call(individual)
    child = individual.copy
    periods = child.constraints.to_periods(child.number_of_slots)
    
    cp = periods.select {|p| p.collision?}
    rp1 = cp.rand_index
    rp2 = cp.rand_index
    rc1 = cp[rp1].rand_colliding_constraint_index
    rc2 = cp[rp2].rand_colliding_constraint_index
    
    cp[rp1].constraints[rc1], cp[rp2].constraints[rc2] = cp[rp2].constraints[rc2], cp[rp1].constraints[rc1]
    
    child.constraints = periods.to_constraints
    child.eval_fitness
    child
  end
end

class SwappingWithCollidingPeriodMutation < Mutation
  def call(individual)
    child = individual.copy
    periods = child.constraints.to_periods(child.number_of_slots)
    
    cp = periods.select {|p| p.collision?}
    rn1 = child.constraints.rand_index
    rp = cp.rand_index
    rc = cp[rp].constraints.rand_index
    rn2 = child.constraints.index(cp[rp].constraints[rc])
    
    child.constraints[rn1], child.constraints[rn2] = child.constraints[rn2], child.constraints[rn1]
    
    child.eval_fitness
    child
  end
end

class SwappingWithCollidingConstraintMutation < Mutation
  def call(individual)
    child = individual.copy
    periods = child.constraints.to_periods(child.number_of_slots)
    
    cp = periods.select {|p| p.collision?}
    rn1 = child.constraints.rand_index
    rp = cp.rand_index
    rc = cp[rp].rand_colliding_constraint_index
    rn2 = child.constraints.index(cp[rp].constraints[rc])
    
    child.constraints[rn1], child.constraints[rn2] = child.constraints[rn2], child.constraints[rn1]
    
    child.eval_fitness
    child
  end
end

class DumbTripleSwapperMutation < Mutation
  def call(individual)
    child = individual.copy
    
    rn1 = child.constraints.rand_index
    rn2 = child.constraints.rand_index
    rn3 = child.constraints.rand_index
    
    c1 = child.constraints[rn1]
    c2 = child.constraints[rn2]
    c3 = child.constraints[rn3]
    
    unless c1 == c3
      child.constraints[rn1] = c2
      child.constraints[rn2] = c3
      child.constraints[rn3] = c1
    else
      child.constraints[rn2] = c3
      child.constraints[rn3] = c2
    end
    
    child.eval_fitness
    child
  end
end

class TripleSwapperWithTwoCollidingPeriodsMutation < Mutation
  def call(individual)
    child = individual.copy
    cp = child.constraints.to_periods(child.number_of_slots).select{|p| p.collision?}
    
    rn1 = child.constraints.rand_index
    rp1 = cp.rand_index
    rc1 = cp[rp1].constraints.rand_index
    rp2 = cp.rand_index
    rc2 = cp[rp2].constraints.rand_index
    rn2 = child.constraints.index(cp[rp1].constraints[rc1])
    rn3 = child.constraints.index(cp[rp2].constraints[rc2])
    
    c1 = child.constraints[rn1]
    c2 = child.constraints[rn2]
    c3 = child.constraints[rn3]
    
    unless c1 == c3
      child.constraints[rn1] = c2
      child.constraints[rn2] = c3
      child.constraints[rn3] = c1
    else
      child.constraints[rn2] = c3
      child.constraints[rn3] = c2
    end 
    
    child.eval_fitness
    child
  end
end

class TripleSwapperWithTwoCollidingConstraintsMutation < Mutation
  def call(individual)
    child = individual.copy
    cp = child.constraints.to_periods(child.number_of_slots).select{|p| p.collision?}
    
    rn1 = child.constraints.rand_index
    rp1 = cp.rand_index
    rc1 = cp[rp1].rand_colliding_constraint_index
    rp2 = cp.rand_index
    rc2 = cp[rp2].rand_colliding_constraint_index
    rn2 = child.constraints.index(cp[rp1].constraints[rc1])
    rn3 = child.constraints.index(cp[rp2].constraints[rc2])
    
    c1 = child.constraints[rn1]
    c2 = child.constraints[rn2]
    c3 = child.constraints[rn3]
    
    unless c1 == c3
      child.constraints[rn1] = c2
      child.constraints[rn2] = c3
      child.constraints[rn3] = c1
    else
      child.constraints[rn2] = c3
      child.constraints[rn3] = c2
    end 
    
    child.eval_fitness
    child
  end
end

########################
# Non-Swapping Mutations
########################

class InvertingMutation < Mutation
  def call(individual)
    child = individual.copy
    constraints_copy = child.constraints.clone
    
    rn1 = child.constraints.rand_index
    rn2 = child.constraints.rand_index
    rn1, rn2 = rn2, rn1 if rn1 > rn2
    
    rn1.upto(rn2) do |i|
      child.constraints[rn2 + rn1 - i] = constraints_copy[i]
    end
    
    child.eval_fitness
    child
  end
end

class InvertingWithCollisionMutation < Mutation
  def call(individual)
    child = individual.copy
    constraints_copy = child.constraints.clone
    periods = child.constraints.to_periods(child.number_of_slots)
    cp = periods.select{|p| p.collision?}
    
    rn1 = child.constraints.rand_index
    rp = cp.rand_index
    rc = cp[rp].rand_colliding_constraint_index
    rn2 = child.constraints.index(cp[rp].constraints[rc])
    rn1, rn2 = rn2, rn1 if rn1 > rn2
    
    rn1.upto(rn2) do |i|
      child.constraints[rn2 + rn1 - i] = constraints_copy[i]
    end
    
    child.eval_fitness
    child
  end
end

class MixingMutation < Mutation
  def call(individual)
    child = individual.copy
    
    rn1 = child.constraints.rand_index
    rn2 = child.constraints.rand_index
    rn1, rn2 = rn2, rn1 if rn1 > rn2

    start = child.constraints[0..rn1-1] # yields all constraints if range is 0..-1, next line prevents this
    start = [] if rn1 == 0
    
    child.constraints = start + child.constraints[rn1..rn2].shuffle + child.constraints[rn2+1..child.constraints.length-1]
    child.eval_fitness
    child
  end
end

class ShiftingMutation < Mutation
  def call(individual)
    child = individual.copy
    constraints_copy = child.constraints.clone
    
    rn1 = child.constraints.rand_index
    rn2 = child.constraints.rand_index    
    rn1, rn2 = rn2, rn1 if rn1 > rn2
    
    child.constraints[rn2] = constraints_copy[rn1]
    rn1.upto(rn2 - 1) do |i|
      child.constraints[i] = constraints_copy[i + 1]
    end
    
    child.eval_fitness
    child
  end
end