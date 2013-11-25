require 'socket'
include Socket::Constants

class Xsocket

  def initialize(port, address)
    @socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    @sockaddr = Socket.sockaddr_in(port, address)
    @chunk_size = 1024
  end

  def chunk_size
    @chunk_size
  end

  def chunk_size=(new_size)
    @chunk_size = new_size
  end

  def listen(&code)
    @socket.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR, true)
    @socket.bind(@sockaddr)
    @socket.listen(5)
    puts 'Listening...'
    client, client_addrinfo = @socket.accept
    begin
      code.call(client)
    end
    return
  end

  def connect(&code)
    @socket.connect(@sockaddr)
    puts 'Connected...'
    code.call(@socket)
  end

  def receive_file(output_path)
    f = File.open(output_path, 'w')
    self.listen do |sock|
      while data = sock.read(@chunk_size)
        f.write(data)
      end
    end
    return
  end

  def send_file(input_path)
    f = File.open(input_path, 'r')
    self.connect do |sock|
      while !f.eof?
        data = f.read(@chunk_size)
        sock.write(data)
      end
    end
    return
  end


  def close
    @socket.close
  end

end
