package mirah.stdlib;

import org.junit.Test

$TestClass
class TestSocket
  $Test
  def testSocketStuff:void
    server = TCPServer.new("localhost", 8085)
    
    client = TCPSocket.new("localhost", 8085)
    server_client = server.accept
    
    client.write("test\n")
    line = server_client.gets
    
    raise "Unexpected line: '#{line}'." if !line.equals("test\n")
    
    client.puts("test");
    line = server_client.gets
    
    raise "Unexpected line: '#{line}'." if !line.equals("test\n")
    
    client.write("test")
    str = server_client.recv(4)
    
    raise "Unexpected read: '#{str}'." if !str.equals("test")
    
    client.close
    server_client.close
    server.close
  end
end