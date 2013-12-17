package mirah.stdlib

import org.junit.Assert
import java.util.concurrent.atomic.AtomicInteger

import mirah.stdlib.test_helpers.TestClass

class TestFile < TestClass
  def test_file:void
    raise "Tmp-dir did not exist." if !File.exists?("/tmp")
    
    file = File.new("/tmp")
    raise "Tmp-dir did not exist." if !file.exists?
    
    if File.exists?("/var/log/syslog")
      file = File.new("/var/log/syslog")
      count_lines = AtomicInteger.new(0)
      
      file.lines.each do |line|
        count_lines.incrementAndGet
        #puts "Line(#{count_lines.get}): #{line}"
      end
      
      lines = count_lines.get
      raise "Didnt count any lines from syslog: '#{lines}'." if lines <= 0
    end
  end
  
  def test_file_write_and_delete:void
    tmppath = "/tmp/testwrite"
    
    File.open(tmppath, "w") do |fp|
      fp.write("test")
    end
    
    cont = File.read(tmppath)
    
    raise "Unexpected content: '#{cont}'." if !cont.equals("test")
    
    File.unlink(tmppath)
  end
  
  def test_file_str_handeling:void
    path = "/var/log/auth.log"
    
    basename = File.basename(path)
    Assert.assertEquals("auth.log", basename)
    
    basename = File.basename(path, ".log")
    Assert.assertEquals("auth", basename)
    
    dirname = File.dirname(path)
    Assert.assertEquals("/var/log", dirname)
  end
  
  def test_file_static_methods:void
    Assert.assertTrue(File.directory?(File.dirname(ENV.fetch("_"))))
    Assert.assertFalse(File.directory?(ENV.fetch("_")))
    
    Assert.assertTrue(File.file?(ENV.fetch("_")))
    Assert.assertFalse(File.file?(File.dirname(ENV.fetch("_"))))
    
    Assert.assertEquals(".log", File.extname("/var/log/auth.log"))
    Assert.assertEquals(".log", File.extname("auth.log"))
    Assert.assertEquals("", File.extname(".profile"))
  end
end