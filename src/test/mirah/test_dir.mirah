package mirah.stdlib

import org.junit.Assert

import mirah.stdlib.test_helpers.TestClass

class TestDir < TestClass
  def test_dir:void
    count = 0
    Dir.foreach(File.dirname(ENV.fetch("_"))) do |file|
      count += 1
    end
    
    raise "Expected files to be found: #{count}" if count <= 0
    
    Assert.assertTrue(Dir.exists?(File.dirname(ENV.fetch("_"))))
    Assert.assertFalse(Dir.exists?("/var/log/syslog"))
  end
  
  def test_dir_mk_and_rm:void
    path = "/tmp/testMkDir"
    Dir.rmdir(path) if File.exists?(path)
    
    Dir.mkdir(path)
    Assert.assertTrue(File.exists?(path))
    Assert.assertTrue(File.directory?(path))
    Dir.rmdir(path)
    Assert.assertFalse(File.exists?(path))
  end
end