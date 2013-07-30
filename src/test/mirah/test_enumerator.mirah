package mirah.stdlib

import org.junit.Test
import org.junit.BeforeClass
import org.junit.AfterClass
import org.junit.Assert
import java.util.concurrent.atomic.AtomicBoolean

$TestClass
class TestEnumerator
  $Test
  def test_enumerator:void
    enum = Enumerator.new do |yielder|
      java::lang::Thread.sleep(100)
      yielder.push("test1")
      
      java::lang::Thread.sleep(100)
      yielder.push("test2")
      
      java::lang::Thread.sleep(100)
    end
    
    thread_id = java::lang::Thread.currentThread.getId
    called_times = 0
    enum.each do |str|
      raise "Expected thread ID to be the same, but it was not: '#{thread_id}' '#{java::lang::Thread.currentThread.getId}'." if thread_id != java::lang::Thread.currentThread.getId
      raise "Got null? '#{str}'" if str == nil
      
      called_times += 1
      puts "Test (#{thread_id}, #{java::lang::Thread.currentThread.getId}): #{str}"
      
      raise "Expected 'test1' but got: '#{str}'." if called_times == 1 and !str.equals("test1")
      raise "Expected 'test2' but got: '#{str}'." if called_times == 2 and !str.equals("test2")
    end
    
    Assert.assertEquals(2, called_times)
  end
  
  $BeforeClass 
  def self.test_gc_enum:void
    called = StringBuffer.new
    enum = Enumerator.new do |yielder|
      yielder.push("test1")
      yielder.push("test2")
      yielder.push("test3")
      called.append("test")
    end
    
    enum.next
    enum.next
    
    called_str = called.toString
    
    raise "Didnt expect 'called' to be 'test' because the enumerator should wait for reads before continuing: '#{called_str}'." if called_str.equals("test") or !called_str.isEmpty
    
    @@yielder_thread_try = "wee"
    @@yielder_thread = enum.yielder_thread
    
    java::lang::Thread.sleep 100
    System.gc
    
    #Notice 'test3' is never tried to be received, and the thread is now a zombie.
  end
  
  $AfterClass
  def self.test_gc:void
    System.gc
    java::lang::Thread.sleep 300
    
    raise "Never tried to set yielder thread." if @@yielder_thread_try == nil
    raise "Yielder thread has not been set." if @@yielder_thread == nil
    raise "Expected 'yielder_thread' to be dead but it wasnt." if @@yielder_thread.isAlive
  end
  
  $Test
  def test_enumerator_arraylist
    al = Array.new([Integer.new(1), Integer.new(2), Integer.new(3)])
    
    enum = Enumerator.new(al.arraylist)
    
    count = 1
    enum.each do |obj|
      Assert.assertEquals(Integer.new(count), obj)
      count += 1
    end
  end
end
