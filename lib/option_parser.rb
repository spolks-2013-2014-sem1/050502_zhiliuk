require 'optparse'

class UserOptionParser

  def initialize
    @options = { port: nil, address: 'localhost', file_path: nil }

    @parser = OptionParser.new do|opts|
      opts.banner = "Usage: server.rb [options]"
      opts.on('-p', '--port port', 'Port') do |port|
        @options[:port] = port;
      end

      opts.on('-a', '--address address', 'Address') do |address|
        @options[:address] = address;
      end

      opts.on('-f', '--file file_path', 'File') do |file_path|
        @options[:file_path] = file_path;
      end

      opts.on('-h', '--help', 'Displays Help') do
        puts opts
        exit
      end
    end


    @parser.parse!
    if options[:port] == nil
      print 'Enter Port: '
      options[:port] = gets.chomp
    end

    if options[:file_path] == nil
      print 'Enter input file path: '
      options[:file_path] = gets.chomp
    end
  end

  def options
    @options
  end
end





