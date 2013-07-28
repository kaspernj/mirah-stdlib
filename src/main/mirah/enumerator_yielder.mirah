package mirah.stdlib

import java.util.concurrent.SynchronousQueue

class EnumeratorYielder
  def initialize(objects:SynchronousQueue)
    @objects = objects
  end
  
  def push(obj:Object)
    @objects.put(obj)
  end
end
