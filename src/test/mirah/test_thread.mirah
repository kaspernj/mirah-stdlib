package mirah.stdlib

import org.junit.Assert
import java.util.concurrent.atomic.AtomicBoolean

import mirah.stdlib.test_helpers.TestClass

class TestThread < TestClass
  def test_mutex_and_monitor
    mutex_called = false
    
    mutex = Mutex.new
    mutex.synchronize do
      mutex_called = true
    end
    
    raise "Mutex-variable was not called." if !mutex_called
    
    monitor_called = false
    
    monitor = Monitor.new
    monitor.synchronize do
      monitor_called = true
    end
    
    raise "Monitor-variable was not called." if !monitor_called
    
    begin
      mutex = Mutex.new
      mutex.synchronize do
        mutex.lock
        puts "This should have failed with deadlock."
      end
      
      raise "This should have failed."
    rescue ThreadError
      #Expected - ignore.
    end
    
    return
  end
  
  def test_thread
    called = AtomicBoolean.new(false)
    
    thread = Thread.new do
      begin
        cur = Thread.current
        cur["test"] = "kasper"
        
        Assert.assertEquals("kasper", Thread.current.fetch("test"))
        Assert.assertEquals("kasper", cur.fetch("test"))
        
        called.set(true)
      rescue => e
        puts "Error: #{e.getMessage}"
      end
    end
    
    java::lang::Thread.sleep(500)
    
    Assert.assertTrue(called.get)
    Assert.assertEquals("kasper", thread.fetch("test"))
  end
end