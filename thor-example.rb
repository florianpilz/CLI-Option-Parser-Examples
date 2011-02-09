require 'rubygems'
require 'thor'
# looks quite good, but seems to have loose support for short options like -f rather than --force

# output of ruby thor.rb or ruby thor.rb help
# Tasks:
#   thor.rb help [TASK]       # Describe available tasks or one specific task
#   thor.rb install APP_NAME  # install one of the available apps
#   thor.rb list [SEARCH]     # list all of the available apps, limited by SEARCH

# output of ruby thor.rb help install
# Usage:
#   thor.rb install APP_NAME
# 
# Options:
#   [--force]        
#   [--alias=ALIAS]  
# 
# install one of the available apps

class App < Thor                                                 # [1]
  map "-L" => :list                                              # [2]

  desc "install APP_NAME", "install one of the available apps"   # [3]
  method_options :force => :boolean, :alias => :string           # [4]
  def install(name)
    user_alias = options[:alias]
    if options.force?
      puts "force"
    end
    puts "installation of #{name}"
  end

  desc "list [SEARCH]", "list all of the available apps, limited by SEARCH"
  def list(search="")
    puts `ls *#{search}*`
  end
end

App.start