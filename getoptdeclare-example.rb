require 'rubygems'
require 'Getopt/Declare'
# yields exactly thos help message if called with -h:
args = Getopt::Declare.new(<<'EOF')

-q, --quiet                  quiet
-f, --files <files:if>...    input files
-n, --number  <num:n>        a float number
-i, --integer <num:i>        an integer number

EOF
# throws an uninformative error message when called with ruby getoptdeclare.rb -f
p args['-q']
p args['-f']
p args.unused