package mirah.stdlib

import org.junit.Test
import org.junit.Assert

import mirah.stdlib.test_helpers.TestClass

$TestClass
class TestTempfile < TestClass
  def test_tempfile:void
    tempfile = Tempfile.new("foo")
    path = tempfile.path
    
    Assert.assertTrue File.exists?(path)
    
    tempfile = nil
    
    GC.start
    Thread.sleep 0.5
    
    Assert.assertFalse File.exists?(path)
  end
end
