require 'rubygems'
require 'main'
# has a custom help format, which I find hard to read
# ruby main.rb -h yields:
# NAME
#   main.rb
# 
# SYNOPSIS
#   main.rb foo [bar=bar] [options]+
# 
# PARAMETERS
#   foo (1 -> int(foo)) 
#   bar=bar (2 ~> float(bar=0.0,1.0)) 
#   --foobar=[foobar] (0 ~> foobar) 
#       the foobar option is very handy 
#   --help, -h 
#   export barfoo=value
Main {
  argument('foo'){
    cast :int
  }
  keyword('bar'){
    arity 2
    cast :float
    defaults 0.0, 1.0
  }
  option('foobar'){
    argument :optional
    description 'the foobar option is very handy'
  }
  environment('BARFOO'){
    cast :list_of_bool
    synopsis 'export barfoo=value'
  }

  def run
    p params['foo'].value
    p params['bar'].values
    p params['foobar'].value
    p params['BARFOO'].value
  end
}