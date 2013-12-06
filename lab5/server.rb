$LOAD_PATH << '../lib'
require 'xsocket.rb'
require 'option_parser.rb'

options = UserOptionParser.new.options

file = File.open(options[:file_path], 'w')

server = Xsocket.new(options[:port], options[:address], 'udp')

server.listen_udp do |client, client_sockadr|
  while(1)

    data = client.recv(1024*8)
    if data == '@'
      puts "remote closed connection"
      break
    end
    p 'write'
    file.write(data.chomp)
  end

end
puts 'Received!!!'
server.close