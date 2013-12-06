$LOAD_PATH << '../lib'
require 'xsocket.rb'
require 'option_parser.rb'

OOB_CHAR = '!'
oob_char = OOB_CHAR

options = UserOptionParser.new.options

file = File.open(options[:file_path], 'r')

client = Xsocket.new(options[:port], options[:address])
client.connect do |server|
  

  counter = 16
  while !file.eof?
    begin
      if counter == 0
        puts "sending 1 byte of OOB data: %s" % oob_char.inspect
        server.send(oob_char, Socket::MSG_OOB)
        counter = 32
        # sleep 1
      else
        # puts "sending 1024 bytes of normal data"
        server.write( file.read(1024*64) )
        counter = counter - 1
      end
    rescue Errno::EPIPE
      puts "remote closed socket"
      exit
    rescue Interrupt
      puts 'STOPED'
      exit
    end
    sleep(0.1)      # wait some time for comfortable testing
  end
  puts 'Sended!!!'
  client.close
end