package mirah.stdlib

class Thread
  def self.current
    return Thread.new(java::lang::Thread.currentThread)
  end
  
  def initialize(blk:Runnable)
    @thread = java::lang::Thread.new(blk)
    vars_spawn
    
    @thread.start
  end
  
  def initialize(thread:java::lang::Thread)
    @thread = thread
    vars_spawn
  end
  
  def vars_spawn
    @thread_id = Long.new(@thread.getId) if @thread_id == nil
    MirahStdlib.THREAD_VARS[@thread_id] = Hash.new unless MirahStdlib.THREAD_VARS.containsKey(@thread_id)
    @vars = Hash(MirahStdlib.THREAD_VARS.get(@thread_id))
  end
  
  def alive?
    @thread.isAlive
  end
  
  def kill
    @thread.interrupt
  end
  
  def exit
    self.kill
  end
  
  def terminate
    self.kill
  end
  
  def fetch(key:Object)
    return @vars.fetch(key)
  end
  
  def [](key:Object)
    return @vars.fetch(key)
  end
  
  def []=(key:Object, val:Object)
    @vars[key] = val
  end
  
  def keys
    return @vars.keys
  end
  
  def join
    @thread.join
  end
end
