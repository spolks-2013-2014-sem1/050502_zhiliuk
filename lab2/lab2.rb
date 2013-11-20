require 'socket'
include Socket::Constants
socket = Socket.new(AF_INET, SOCK_STREAM, 0)                     #create new server sock
sockaddr = Socket.sockaddr_in(22328, 'localhost')                #=> "\x02\x00W8\x7F\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00"
socket.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR, true) #Set ::Option. for reusing addr
socket.bind(sockaddr)                                            # Bind socket to addr
socket.listen(5)                                                 #start listening
puts 'Listening...'
client, client_addrinfo = socket.accept                          #on connect 
begin
  client.puts Time.now.utc 
  puts "Client => '#{Time.now.utc}'"
rescue Interrupt                                                 # ctrl+c interrupt catch (not working idkw)
  puts "I refuse to be stopped!"
ensure
  socket.close
end
