$LOAD_PATH << '../lib'
require 'xsocket.rb'
require 'option_parser.rb'

OOB_CHAR = '!'
UDP_CHAR = '@'

options = UserOptionParser.new.options

file = File.open(options[:file_path], 'r')

client = Xsocket.new(options[:port], options[:address], 'udp')
client.connect do |server|

  server.send(UDP_CHAR, 0)
  sleep(1)
  while !file.eof?
    begin
      puts "sending 1024*8 bytes of normal data"
      server.puts( file.read(1024*8) )
    rescue Errno::EPIPE
      puts "remote closed socket"
      exit
    rescue Interrupt
      puts 'STOPED'
      exit
    end
    sleep(0.2)      # wait some time for comfortable testing
  end
  server.send(UDP_CHAR, 0)
  puts 'Sended!!!'
  client.close
end