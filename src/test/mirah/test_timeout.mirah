package mirah.stdlib

import org.junit.Test

$TestClass
class TestTimeout
  $Test
  def TestSimpleCall:void
    puts "testSimpleCall"
    
    called = false
    Timeout.timeout(5.0) do
      java::lang::Thread.sleep(500)
      called = true
      return nil
    end
    
    raise "Expected timeout to actually call stuff." if !called
  end
  
  $Test
  def testTimeout
    puts "testTimeout"
    called = false
    
    begin
      Timeout.timeout(0.5) do
        java::lang::Thread.sleep(1000)
        called = true
        return nil
      end
      
      raise "Didnt expect this to actually happen."
    rescue TimeoutError
      #This is expected.
    end
    
    raise "Didnt expect the call to actually be made but it was: #{called}." if called
    return
  end
  
  $Test
  def testReturnValue
    puts "testReturnValue"
    
    res = Timeout.timeout(0.5) do
      java::lang::Thread.sleep(100)
      return "test"
    end
    
    raise "Got null: #{res}" if res == nil
    raise "Expected string return but got: '#{res.getClass.getName}'." if !res.getClass.getSimpleName.equals("String")
    raise "Expected 'test' content but got: '#{res}'." if !res.equals("test")
    
    return
  end
  
  $Test
  def testCustomErrors
    puts "testStubbornThread"
    
    begin
      Timeout.timeout(0.5, MyWeirdError.class) do
        run = true
        
        while run
          begin
            java::lang::Thread.sleep(2000)
            nil
          rescue InterruptedException
            puts "DONT WANT TO DIE!"
            nil
            #ignore - be stubborn! Dont want to die with normal interrupt!
          end
        end
        
        return nil
      end
      
      raise "This should not happen."
    rescue MyWeirdError
      #expected
    end
    
    return
  end
  
  $Test
  def testOnInterrupt
    timeout = Timeout.new(0.25, nil)
    
    on_interrupt_called = false
    timeout.on_interrupt do
      on_interrupt_called = true
    end
    
    begin
      timeout.run_timeout do
        java::lang::Thread.sleep(500)
        return nil
      end
      
      raise "Never expected to reach this."
    rescue TimeoutError
      #Expected to happen.
    end
    
    raise "Expected 'on_interrupt_called' to be true but it wasnt: '#{on_interrupt_called}'." if !on_interrupt_called
    return
  end
end

class MyWeirdError < Throwable; end
