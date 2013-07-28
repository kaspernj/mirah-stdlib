package mirah.stdlib

class Monitor
  def initialize
    @lock = java::util::concurrent::locks::ReentrantLock.new
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