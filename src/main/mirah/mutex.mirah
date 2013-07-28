package mirah.stdlib

class Mutex
  def initialize
    @lock = java::util::concurrent::locks::ReentrantLock.new
  end
  
  def lock
    my_code = Integer.new(System.identityHashCode(java::lang::Thread.currentThread))
    
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
    lock()
    
    begin
      blk.run
    ensure
      self.unlock
    end
  end
end