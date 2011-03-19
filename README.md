Final Conclusion
================

To spare you some time, I will start with the conclusion and supply detailed information later on.

Several command-line option-parser were implemented to make it easier to compare them.
An overview of pros and cons of each option are listed below.

My personal conclusion is that [Micro-Optparse](http://florianpilz.github.com/micro-optparse/) and [Trollop](http://trollop.rubyforge.org/) are -- by far -- the best option-parser available.
Both have an expressive, clear, short and easy to use syntax.

[Micro-Optparse](http://florianpilz.github.com/micro-optparse/) is 70 lines long and provides strong validations.
Therefore it's ideal to just copy &amp; paste the option-parser into your script rather using a gem.

[Trollop](http://trollop.rubyforge.org/) adjusts the help message to the width of your terminal, producing the best-looking help message.
It's around 800 lines long and provides simple validations.
Therefore it's the best option if simple validations are good enough and if size doesn't matter (or if you are looking for a gem).

[OptionParser](http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html) (optparse) is noteworthy as well, which is a parser contained in the ruby standard library.

For more details and details about other option-parser, read below.

Pros and Cons of each Option
============================

[Micro-Optparse](http://florianpilz.github.com/micro-optparse/)
---------------------------------------------------------------

  - is 70 lines short
  - creates short (`-m`) and long (`--mutation`) accessors automatically from symbols (`:mutation`)
  - if no default value is given, the argument is treated as a switch, i.e. `true` if given, `false` otherwise (you can specify `--no-verbose` to set it to false)
  - shows default values in help message
  - supplied arguments are checked to have the same type as the default value
  - yields focused error messages, i.e. `Severity must be in [1, 2, 3, 4]`
  - has very strong validations (if value in array, matches regular expression or if lambda evaluates to true given the supplied value)
  - **Summary:** best overall option with strong validations and short syntax -- ideal to copy &amp; paste into your script if you want to avoid gem-dependencies

[Trollop](http://trollop.rubyforge.org/)
----------------------------------------

  - creates short (`-f`) and long (`--file`) accessors automatically from symbols (`:file`)
  - shows default values in help message (if available)
  - if default values are given, supplied arguments are checked to have the same type
  - help message is adjusted to current terminal width and very readable
  - yields focused error messages, i.e. `-num needs an Integer`
  - validations can only consist of an error message and an expression which evaluates to Boolean
  - **Summary:** best option if simple validations are sufficient and if you are looking for an external library (gem)

[OptionParser](http://www.ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html) (optparse)
--------------------------------------------------------------------------------------------------------

  - part of the ruby library
  - accessor must be specified manually
  - must save matched option by hand (annoying, because this part could have been automated very easily)
  - default values can be faked by setting them beforehand and overwriting them while parsing the arguments
  - expected type, i.e. Integer, can be given
  - throws an error instead of a helpful message, if a problem occured (wrong type for example)
  - validations can only check if value is in an array of predefined values
  - **Summary:** best option in the standard library, but [Micro-Optparse](http://florianpilz.github.com/micro-optparse/) should be preferred if possible, because it replaces all weaknesses by strength (strong validations, informative error messages, proper default values, ...)
  
[Switches](https://github.com/thoran/switches)
----------------------------------------------

  - wrapper for OptionParser
  - short and expressive methods
  - match is saved automatically and default values can be given easily
  - no validations
  - also throws unexpressive errors instead of a helpful message
  - **Summary:** good option, but lacks proper documentation and has no validations -- use [Micro-Optparse](http://florianpilz.github.com/micro-optparse/) instead

[Optiflag](http://optiflag.rubyforge.org/quick.html)
----------------------------------------------------

  - only shows the short accessor, even if a long accessor was defined
  - no possibility to declare expected type
  - syntax is a bit lengthy
  - very powerful validations, i.e. if value is in array of predefined values or if a given regex matches the input
  - **Summary:** apart from [Micro-Optparse](http://florianpilz.github.com/micro-optparse/) best option concerning strong validations, but lacks elegance

[Choice](http://choice.rubyforge.org/)
--------------------------------------

  - accessors must be specified manually
  - _lengthy syntax_
  - always shows help if a validation failed, i.e. no details what went wrong
  - default values and expected type can be declared
  - validation if input is in array of predefined values
  - possibility to manipulate the input before it is saved
  - **Summary:** good option with a descriptive syntax and good validations -- however, even the small example contained in this repository is longer than the parser of [Micro-Optparse](http://florianpilz.github.com/micro-optparse/)
  
[Thor](https://github.com/wycats/thor)
--------------------------------------

  - more a tool like rake, rather an option parser
  - only generates long accessors
  - shows default values of each argument, but doesn't allow descriptions
  - checks type of user input against type of default values and makes implicit typecasts
  - no validations possible
  - **Summary:** very good &amp; minimalistic option for subcommands, but it's use is limited (no short accessors, no validations, no argument descriptions)
  
[Main](https://github.com/ahoward/main)
---------------------------------------

  - no dash in front of the accessor
  - help message uses a strange syntax to describe arity and type of each argument, looks ugly
  - default values can be given
  - simple validations, which evaluate to Boolean, can be used
  - will only print `invalid keyword #{keyword}` if a validation failed
  - lengthy syntax
  - **Summary:** viable option with a weird but descriptive syntax with lambda expressions for validations

[Getopt-Declare](http://getoptdeclare.rubyforge.org/)
-----------------------------------------------------

  - always throws an error, even if input is OK
  - no default values
  - expected type can be declared, but input is not cast to this type
  - accessors must be specified manually
  - **Summary:** _Do Not Use!_

Other alternatives, which weren't worth my time
-----------------------------------------------

  - [getopt](https://github.com/djberg96/getopt)
  - [usage](http://rubydoc.info/gems/usage/0.0.4/frames)
  - [ropt](http://devel.korinkan.co.jp/ruby-ropt/README.ja.html)
  - [getoptlong](http://www.ruby-doc.org/stdlib/libdoc/getoptlong/rdoc/index.html) (resides in ruby library, like optparse)
  - and many more