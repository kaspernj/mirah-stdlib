package mirah.stdlib

import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.SynchronousQueue
import java.util.ArrayList

interface EnumeratorOneYielderBlockArgument do
  def run(yielder:EnumeratorYielder):void; end
end

interface EnumeratorOneBlockArgument do
  def run(obj:Object):void; end
end

class Enumerator
  def initialize(blk:EnumeratorOneYielderBlockArgument)
    @queue = SynchronousQueue.new #Use a queue in order to keep track of objects between threads.
    queue = @queue
    
    @yielder = EnumeratorYielder.new(@queue) #Yielder object that will be given to user, so he can pass objects into the enumerator in a new thread.
    yielder = @yielder
    
    @threads_waiting = ArrayList.new #Keeps list of waiting threads to interrupt them, when the block is done running.
    threads_waiting = @threads_waiting
    
    @lock = Mutex.new
    lock = @lock
    
    @stopped = AtomicBoolean.new(false)
    stopped = @stopped
    
    @yielder_thread = Thread.new do
      begin
        blk.run(yielder)
      rescue InterruptedException
        #This happens if the receiver dont want to receive all objects and abandons the enumerator - ignore with no warning, since this should be an expected behaviour. The thread got called by 'finalize' down below.
      ensure
        stopped.set(true)
        lock.lock
        
        begin
          threads_waiting.each do |thread|
            Thread(thread).kill
          end
        ensure
          lock.unlock
        end
        
        queue.offer(StopIteration.new)
      end
    end
  end
  
  def is_stopped
    return @stopped.get
  end
  
  #Stops the 'yielder_thread' from becoming a zombie and leaking memory.
  def finalize
    @yielder_thread.kill if @yielder_thread.alive?
  end
  
  def yielder_thread
    return @yielder_thread
  end
  
  def next
    cur_thread = Thread.current
    raise StopIteration.new if !@yielder_thread.alive? or self.is_stopped
    
    @lock.lock
    begin
      @threads_waiting.add(cur_thread) if !@threads_waiting.contains(cur_thread)
    ensure
      @lock.unlock
    end
    
    begin
      ele = @queue.take
      @lock.lock
      @threads_waiting.remove(cur_thread)
      @lock.unlock
    rescue InterruptedException
      @lock.lock
      @threads_waiting.remove(cur_thread)
      @lock.unlock
      raise StopIteration.new
    end
    
    #This can be given by the yielder thread to prevent nexts.
    raise StopIteration.new if ele.getClass == StopIteration.class
    
    return ele
  end
  
  def each(blk:EnumeratorOneBlockArgument):void
    begin
      while true
        blk.run(self.next)
      end
    rescue StopIteration => e
      #Ignore - this is supposed to happen, when there is no more elements.
    end
  end
end