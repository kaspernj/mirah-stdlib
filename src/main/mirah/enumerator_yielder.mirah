package mirah.stdlib

import java.util.concurrent.SynchronousQueue
import java.util.concurrent.TimeUnit
import java.lang.InterruptedException

class EnumeratorYielder
  def initialize(objects:SynchronousQueue)
    @objects = objects
    @stopped = false
  end
  
  def push(obj:Object)
    loop do
      # Try to offer object and break if someone took it.
      break if @objects.offer(obj, 100, TimeUnit.MILLISECONDS)
      
      # Raise exception if the enumerator is stopped.
      raise InterruptedException.new if @stopped
    end
  end
  
  def stopped=(newval:boolean)
    @stopped = newval
  end
  
  def stopped
    return @stopped
  end
end
