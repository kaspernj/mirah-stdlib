package mirah.stdlib

import java.util.concurrent.locks.ReentrantLock
import java.lang.Thread

class Mutex
  def initialize
    @lock = ReentrantLock.new
  end
  
  def lock
    my_code = Integer.new(System.identityHashCode(Thread.currentThread))
    
    if @locked_by != nil && @locked_by.equals(my_code)
      raise ThreadError.new("deadlock; recursive locking")
    end
    
    @lock.lock
    @locked_by = my_code
  end
  
  def unlock
    @locked_by = nil
    @lock.unlock
  end
  
  def locked
    return @lock.isLocked
  end
  
  def synchronize(blk:Runnable)
    lock
    
    begin
      blk.run
    ensure
      unlock
    end
  end
end
