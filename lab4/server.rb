$LOAD_PATH << '../lib'
require 'xsocket.rb'
require 'option_parser.rb'

options = UserOptionParser.new.options

F_SETOWN = 8    # set manual as not defined in Fcntl

file = File.open(options[:file_path], 'w')

server = Xsocket.new(options[:port], options[:address])

received = 0

server.listen do |client|
  puts "incoming connection from %s" % client.remote_address.inspect_sockaddr

  trap(:URG) do
    begin
      data = client.recv(100, Socket::MSG_OOB)
    rescue Exception => err  
    ensure
      puts puts "got %s bytes of normal data" % received
    end
  end

  client.fcntl(F_SETOWN, Process.pid)   # so we will get sigURG
  while data = client.read(1024*64) do
    file.write(data)
    if client.eof?
      puts "remote closed connection"
      break
    end
    received += data.size
  end
  puts 'Received!!!'
  server.close
end