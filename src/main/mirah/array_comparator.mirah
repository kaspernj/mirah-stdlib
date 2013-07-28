package mirah.stdlib

import java.util.Comparator

#This class is used to make the "Array.sort"-method.
class ArrayComparator
  implements Comparator
  
  def initialize(blk:ArraySortInterface)
    @blk = blk
  end
  
  def compare(obj1:Object, obj2:Object):int
    return @blk.run(obj1, obj2)
  end
end