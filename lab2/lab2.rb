require 'socket'
include Socket::Constants
require 'optparse'


options = { port: nil, address: 'localhost' }

parser = OptionParser.new do|opts|
  opts.banner = "Usage: server.rb [options]"
  opts.on('-p', '--port port', 'Port') do |port|
    options[:port] = port;
  end

  opts.on('-a', '--address address', 'Address') do |address|
    options[:address] = address;
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end

parser.parse!

if options[:port] == nil
  print 'Enter Port: '
  options[:port] = gets.chomp
end

# Create new server sock
socket = Socket.new(AF_INET, SOCK_STREAM, 0)
# => "\x02\x00W8\x7F\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00"
sockaddr = Socket.sockaddr_in(options[:port], options[:address])
# Set ::Option. for reusing addr
socket.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR, true)
# Bind socket to addr
socket.bind(sockaddr)
# Start listening
socket.listen(1)
puts 'Listening...'
# On connect 
client, client_addrinfo = socket.accept
begin
  client.puts Time.now.utc 
  puts "Client => '#{Time.now.utc}'"
# ctrl+c interrupt catch (not working idkw)  
rescue Interrupt
  puts "I refuse to be stopped!"
ensure
  socket.close
end
