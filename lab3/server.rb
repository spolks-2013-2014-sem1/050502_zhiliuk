$LOAD_PATH << '../lib'
require 'xsocket.rb'
require 'option_parser.rb'

options = UserOptionParser.new.options


server =  Xsocket.new(options[:port], options[:address])
server.receive_file options[:file_path]
server.close