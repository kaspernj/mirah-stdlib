package mirah.stdlib

import java.util.ArrayList
import java.util.Arrays
import java.util.Collections
import java.util.List
import java.util.Random

interface ArrayEachInterface do
  def run(val:Object); end
end

interface ArrayCollectInterface do
  def run(val:Object):Object; end
end

interface ArrayEachBooleanValInterface do
  def run(val:Object):boolean; end
end

interface ArraySortInterface do
  def run(val1:Object, val2:Object):int; end
end

class Array
  def initialize(arraylist:ArrayList)
    @al = arraylist
  end
  
  def initialize(list:List)
    @al = ArrayList.new(list)
  end
  
  def initialize(arr:Object[])
    @al = ArrayList.new(Arrays.asList(arr))
  end
  
  def initialize
    @al = ArrayList.new
  end
  
  def arraylist
    return @al
  end
  
  def real_array
    return @al
  end
  
  def push(obj:Object)
    @al.add(obj)
    return self
  end
  
  #Method name '<<' not supported in Mirah at this time - commented out.
  #def <<(obj:Object):void
  #  self.push(obj)
  #end
  
  def []=(index:int, val:Object)
    return @al.add(index, val)
  end
  
  def delete(obj:Object)
    if @al.remove(obj)
      return obj
    else
      return nil
    end
  end
  
  def length
    return @al.size
  end
  
  def size
    return @al.size
  end
  
  def count
    return @al.size
  end
  
  def empty
    return @al.isEmpty
  end
  
  def count(obj:Object)
    count_i = 0
    @al.each do |obj_i|
      count_i += 1 if obj == obj_i
    end
    
    return count_i
  end
  
  def clear
    @al.clear
    return self
  end
  
  def fetch(index:int)
    return @al.get(index)
  end
  
  def fetch(index:int, default:Object)
    begin
      return @al.get(index)
    rescue IndexOutOfBoundsException
      return default
    end
  end
  
  def [](index:int)
    begin
      return self.fetch(index)
    rescue IndexOutOfBoundsException
      return nil
    end
  end
  
  def at(index:int)
    return self.fetch(index)
  end
  
  def first
    return self.fetch(0)
  end
  
  def last
    return nil if self.empty
    return self.fetch(self.length - 1)
  end
  
  def include?(obj:Object)
    return @al.contains(obj)
  end
  
  def slice(start:int, length:int)
    return Array.new(ArrayList.new(@al.subList(start, length)))
  end
  
  def [](start:int, length:int)
    return self.slice(start, length)
  end
  
  def shift
    return @al.remove(0)
  end
  
  def shift(length:int)
    arr = Array.new
    
    1.upto(length) do
      arr.push(self.shift)
    end
    
    return arr
  end
  
  def unshift(obj:Object)
    newarr = ArrayList.new
    newarr.add(obj)
    
    @al.each do |obj|
      newarr.add(obj)
    end
    
    @al = newarr
  end
  
  def pop
    return @al.remove(@al.size - 1)
  end
  
  def pop(length:int)
    arr = Array.new
    
    1.upto(length) do
      arr.push(self.pop)
    end
    
    return arr
  end
  
  def each(blk:ArrayEachInterface)
    al = @al
    
    if blk != nil
      @al.each do |val|
        blk.run(val)
      end
      
      return nil
    else
      enum = Enumerator.new do |yielder|
        al.each do |val|
          yielder.push(val)
        end
      end
      
      return enum
    end
  end
  
  def collect(blk:ArrayCollectInterface)
    newarr = Array.new
    
    @al.each do |obj|
      res = blk.run(obj)
      newarr.push(res)
    end
    
    return newarr
  end
  
  def delete_if(blk:ArrayEachBooleanValInterface)
    removes = Array.new
    
    @al.each do |obj|
      removes.push(obj) if blk.run(obj)
    end
    
    self.delete_arr(removes)
    return removes
  end
  
  def keep_if(blk:ArrayEachBooleanValInterface)
    removes = Array.new
    
    @al.each do |obj|
      removes.push(obj) if !blk.run(obj)
    end
    
    self.delete_arr(removes)
    return removes
  end
  
  def compact
    newarr = Array.new
    
    @al.each do |obj|
      newarr.push(obj) if obj != nil
    end
    
    return newarr
  end
  
  def eql?(other:Array)
    self_l = self.length
    return false if self_l != other.length
    
    0.upto(self_l) do |count|
      return false if self[count] != other[count]
    end
    
    return true
  end
  
  def replace(other:Array)
    @al = other.arraylist
  end
  
  def map(blk:ArrayCollectInterface)
    return self.collect(blk)
  end
  
  def join(str:String)
    strb = StringBuffer.new
    
    first = true
    @al.each do |obj|
      strb.append(str) if !first
      first = false if first
      strb.append(obj.toString)
    end
    
    return strb.toString
  end
  
  def sort
    newarr = @al.toArray
    Arrays.sort(newarr)
    return Array.new(newarr)
  end
  
  def sort(blk:ArraySortInterface)
    new_al = ArrayList(@al.clone)
    comparator = ArrayComparator.new(blk)
    sorted_al = Collections.sort(new_al, comparator)
    return Array.new(new_al)
  end
  
  def uniq
    newarr = Array.new
    
    @al.each do |obj|
      newarr.push(obj) if !newarr.include?(obj)
    end
    
    return newarr
  end
  
  def shuffle
    newarr = ArrayList(@al.clone)
    Collections.shuffle(newarr, Random.new)
    return Array.new(newarr)
  end
  
  def to_a
    return self
  end
  
  def to_ary
    return self
  end
  
  def to_s
    return @al.toString
  end
  
  def toString
    return self.to_s
  end
  
  def inspect
    return self.to_s
  end
  
  private
  
  def delete_arr(removes:Array):void
    inst = self
    removes.each do |ele_remove|
      inst.delete(ele_remove)
    end
  end
end