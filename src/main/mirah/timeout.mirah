package mirah.stdlib

class Timeout
  def initialize(seconds:double, error:Class = nil)
    @sleeptime = Math.round(seconds * 1000.0)
    @error_class = error
  end
  
  def run_timeout(blk:TimeoutBlock):Object
    thread_cur = java::lang::Thread.currentThread
    instance = self
    @done = false
    on_interrupt = @on_interrupt
    error_class = @error_class
    sleeptime = @sleeptime
    
    if error_class == nil
      expect_interrupt = true
    else
      expect_interrupt = false
    end
    
    thread_chk = java::lang::Thread.new do
      begin
        java::lang::Thread.sleep(sleeptime)
        
        if !instance.is_done
          #Sometimes it can be nice to be notified about a thread should be interrupted like on socket operations, which can block the interrupting.
          if on_interrupt != nil
            on_interrupt.each do |callback_blk|
              begin
                on_interrupt_blk = Runnable(callback_blk)
                on_interrupt_blk.run
                nil
              rescue => e
                System.err.println("Error while running 'on_interrupt' block: #{e.getMessage}")
                e.printStackTrace(System.err)
                nil
              end
            end
          end
          
          if error_class == nil
            #No custom error have been given - just try to interrupt the running thread normally.
            puts "Sending interrupt to thread."
            thread_cur.interrupt if !instance.is_done
          else
            puts "Sending custom error to thread."
            #Custom error has been given - make instance and try to stop the thread with that.
            error_obj = Throwable(error_class.newInstance)
            thread_cur.stop(error_obj) if !instance.is_done
          end
        end
        
        return
      rescue InterruptedException
        #Ignore - block was done running before wait was reached and the check-thread was interrupted to not use resources.
      end
    end
    
    thread_chk.start
    
    #Ensure-bug in Mirah forces a lot of exception-stuff :-(
    res = nil
    
    begin
      begin
        res = blk.run
      ensure
        @done = true
      end
      
      thread_chk.interrupt if thread_chk.isAlive
    rescue InterruptedException => e
      if expect_interrupt
        raise TimeoutError.new
      else
        raise e
      end
    end
    
    return res
  end
  
  def is_done:boolean
    return @done
  end
  
  def on_interrupt(blk:Runnable):void
    @on_interrupt = java::util::ArrayList.new if @on_interrupt == nil
    @on_interrupt.add(blk)
    return
  end
  
  def self.timeout(seconds:double, blk:TimeoutBlock):Object
    return Timeout.new(seconds, nil).run_timeout(blk)
  end
  
  def self.timeout(seconds:double, error:Class = nil, blk:TimeoutBlock = nil):Object
    return Timeout.new(seconds, error).run_timeout(blk)
  end
  
  interface TimeoutBlock do
    def run:Object; end
  end
end

#This error is being thrown, when a timeout is reached and block is not done running.
class TimeoutError < InterruptedException; end