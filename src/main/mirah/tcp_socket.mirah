package mirah.stdlib

import java.net.Socket

class TCPSocket
  def initialize(sock:Socket)
    @socket = sock
    @in = @socket.getInputStream
    @out = @socket.getOutputStream
  end
  
  def initialize(host:String, port:int)
    @socket = java::net::Socket.new(host, port)
    @in = @socket.getInputStream
    @out = @socket.getOutputStream
  end
  
  def addr
    ip_addr_str = @socket.getLocalAddress.toString
    ip_addr_str = ip_addr_str.substring(1, ip_addr_str.length)
    
    return [nil, @socket.getLocalPort, ip_addr_str]
  end
  
  def puts(str:String)
    self.write("#{str}\n")
  end
  
  def write(str:String)
    @out.write(str.getBytes)
  end
  
  def gets
    return self.sock_read_line
  end
  
  def recv(length:int)
    sb = StringBuffer.new
    buffer = char[length]
    read_total = 0
    
    while read_total < length
      ch_int = @in.read
      raise java::io::IOException, "Socket seems to have closed on us?" if ch_int == -1
      sb.append(char(ch_int))
      read_total += 1
      break if read_total >= length
    end
    
    return sb.toString
  end
  
  def close
    @socket.close
  end
  
  private
  
  #Reads a line from the socket and returns it as a string.
  def sock_read_line
    sb = StringBuffer.new
    
    while(true)
      ch_int = @in.read
      raise java::io::IOException, "Socket seems to have closed on us?" if ch_int == -1
      sb.append(char(ch_int))
      break if ch_int == 10
    end
    
    return sb.toString
  end
end