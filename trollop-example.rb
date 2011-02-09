require 'rubygems'
require 'trollop'
# automatically generates shortcuts
opts = Trollop::options do
  version "test 1.2.3 (c) 2008 William Morgan"
  banner <<-EOS
Test is an awesome program that does something very, very important.

Usage:
       test [options] <filenames>+
where [options] are:
EOS

  opt :ignore, "Ignore incorrect values"
  opt :file, "Extra data filename to read in, with a very long option description like this one",
        :type => String
  opt :volume, "Volume level", :default => 3.0
  opt :iters, "Number of iterations", :default => 5
end
Trollop::die :volume, "must be non-negative" if opts[:volume] < 0
Trollop::die :file, "must exist" unless File.exist?(opts[:file]) if opts[:file]