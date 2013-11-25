$LOAD_PATH << '../lib'
require 'xsocket.rb'
require 'option_parser.rb'

options = UserOptionParser.new.options


client =  Xsocket.new(options[:port], options[:address])
client.send_file options[:file_path]
client.close