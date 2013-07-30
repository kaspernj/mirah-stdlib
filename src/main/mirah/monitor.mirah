package mirah.stdlib

import java.util.concurrent.locks.ReentrantLock

class Monitor
  def initialize
    @lock = ReentrantLock.new
  end
  
  def synchronize(blk:Runnable)
    @lock.lock
    
    begin
      blk.run
    ensure
      @lock.unlock
    end
  end
end