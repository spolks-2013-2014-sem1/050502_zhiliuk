require 'socket'
include Socket::Constants
# Create new server sock
socket = Socket.new(AF_INET, SOCK_STREAM, 0)
# => "\x02\x00W8\x7F\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00"
sockaddr = Socket.sockaddr_in(22328, 'localhost')
# Set ::Option. for reusing addr
socket.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR, true)
# Bind socket to addr
socket.bind(sockaddr)
# Start listening
socket.listen(5)
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
