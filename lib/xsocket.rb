require 'socket'
include Socket::Constants

class Xsocket

  def initialize(port, address, protocol)
    if protocol == 'udp'
      @socket = Socket.new(Socket::AF_INET, Socket::SOCK_DGRAM, 0)
    else
      @socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    end
    @sockaddr = Socket.sockaddr_in(port, address)
    @chunk_size = 1024
  end

  def socket
    @socket
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
    @socket.listen(1)
    puts 'Listening...'
    client, client_addrinfo = @socket.accept
    begin
      code.call(client)
    rescue Errno::ECONNRESET => e
      puts 'Client disconnected' + e.msg
    rescue Errno::EPIPE => e
      puts 'Client disconnected' + e.msg
    end
    return
  end

  def listen_udp(&code)
    @socket.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR, true)
    @socket.bind(@sockaddr)
    puts 'Listening...'
    while(1)
      msg, client_sockaddr = @socket.recvfrom(1)
      break if (msg == '@')
    end
    begin
      code.call(@socket, client_sockaddr)
    rescue Errno::ECONNRESET => e
      puts 'Client disconnected' + e.msg
    rescue Errno::EPIPE => e
      puts 'Client disconnected' + e.msg
    end
    return
  end

  def connect(&code)
    @socket.connect(@sockaddr)
    begin
      puts 'Connected...'
      code.call(@socket)
    rescue Errno::EPIPE => e
      puts 'Server disconnected' + e.msg
    end
  end

  def close
    @socket.close if @socket
  end

end
