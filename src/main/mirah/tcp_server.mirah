package mirah.stdlib

class TCPServer
  def initialize(host:String, port:int)
    @socket = java::net::ServerSocket.new(port)
  end
  
  def accept
    return TCPSocket.new(@socket.accept)
  end
  
  def close
    @socket.close
  end
end