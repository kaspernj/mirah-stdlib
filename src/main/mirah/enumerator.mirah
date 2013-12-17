package mirah.stdlib

import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.SynchronousQueue
import java.util.ArrayList
import java.util.concurrent.TimeUnit
import java.util.concurrent.locks.ReentrantLock
import java.lang.Thread
import java.lang.InterruptedException

interface EnumeratorOneYielderBlockArgument do
  def run(yielder:EnumeratorYielder):void; end
end

interface EnumeratorOneBlockArgument do
  def run(obj:Object):void; end
end

class Enumerator
  def initialize(blk:EnumeratorOneYielderBlockArgument)
    # Use a queue in order to keep track of objects between threads.
    @queue = SynchronousQueue.new(true)
    queue = @queue
    
    # The yielder object which the user can push objects through.
    @yielder = EnumeratorYielder.new(@queue) #Yielder object that will be given to user, so he can pass objects into the enumerator in a new thread.
    yielder = @yielder
    
    # Exception that will be used to stop iteration.
    @stop = StopIteration.new
    stop = @stop
    
    # The thread which will accept the incoming objects.
    @yielder_thread = Thread.new do
      begin
        blk.run(yielder)
      rescue InterruptedException
        #This happens if the receiver dont want to receive all objects and abandons the enumerator - ignore with no warning, since this should be an expected behaviour. The thread got called by 'finalize' down below.
      ensure
        #Sleep to give time for last calling thread to get its result before killing it off.
        yielder.stopped = true
        
        # Keep offering stop objects to prevent any waiting thread from becoming a zombie. If no one is accepting, then it must mean we have successfully stopped without any zombie-waiting threads.
        loop do
          break unless queue.offer(stop, 100, TimeUnit.MILLISECONDS)
        end
      end
    end
    
    @yielder_thread.start
  end
  
  def initialize(arr:ArrayList)
    @arr = arr
    @count = 0
  end
  
  #Stops the 'yielder_thread' from becoming a zombie and leaking memory.
  def finalize:void
    @yielder.stopped = true if @yielder
  end
  
  def yielder_thread
    return @yielder_thread
  end
  
  def next
    # If enumerator should function based on array-list which is faster.
    if @arr
      raise StopIteration.new if @count >= @arr.size
      ele = @arr.get(@count)
      @count += 1
      return ele
    end
    
    raise StopIteration.new if !@yielder_thread.isAlive or @yielder.stopped
    ele = @queue.take
    raise @stop if ele == @stop
    return ele
  end
  
  def each(blk:EnumeratorOneBlockArgument):void
    begin
      loop do
        blk.run(self.next)
      end
    rescue StopIteration => e
      #Ignore - this is supposed to happen, when there are no more elements.
    end
  end
end
