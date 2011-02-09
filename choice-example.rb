require 'rubygems'
require 'choice'
# very readable
# yields:
# Usage: choice-example.rb [-hpv]
# 
# Specific options:
#     -h, --host=HOST                  The hostname or ip of the host to bind to (default 127.0.0.1)
#     -p, --port=PORT                  The port to listen on (default 21)
# 
# Common options: 
#         --help                       Show this message
#     -v, --version                    Show version

PROGRAM_VERSION = 4

Choice.options do
  header ''
  header 'Specific options:'

  option :host do
    short '-h'
    long '--host=HOST'
    desc 'The hostname or ip of the host to bind to (default 127.0.0.1)'
    default '127.0.0.1'
  end

  option :port do
    short '-p'
    long '--port=PORT'
    desc 'The port to listen on (default 21)'
    cast Integer
    default 21
  end

  separator ''
  separator 'Common options: '

  option :help do
    long '--help'
    desc 'Show this message'
  end

  option :version do
    short '-v'
    long '--version'
    desc 'Show version'
    action do
      puts "ftpd.rb FTP server v#{PROGRAM_VERSION}"
      exit
    end
  end
end

puts 'port: ' + Choice.choices[:port].to_s