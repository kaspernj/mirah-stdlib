package mirah.stdlib

import java.util.LinkedHashMap
import java.util.Collections

interface HashEachKeyValInterface do
  def run(keyVal:Object, val:Object); end
end

interface HashEachKeyValBoolInterface do
  def run(keyVal:Object, val:Object):boolean; end
end

class Hash
  def initialize
    @hash = Collections.synchronizedMap(LinkedHashMap.new)
  end
  
  def initialize(hash_map:java.util.HashMap)
    @hash = Collections.synchronizedMap(LinkedHashMap.new)
    @hash.putAll(hash_map)
  end
  
  def real_hash
    return @hash
  end
  
  def store(key:Object, val:Object)
    @hash.put(key, val)
    return self
  end
  
  def []=(key:Object, val:Object)
    return self.store(key, val)
  end
  
  def clear
    @hash.clear
    return self
  end
  
  def size
    return @hash.size
  end
  
  def length
    return @hash.size
  end
  
  def empty
    return @hash.isEmpty
  end
  
  def key(value:Object)
    select_val = self.select do |key_val, val|
      return true if value == val
    end
    
    return select_val.keys.first
  end
  
  def keys
    arr = Array.new
    @hash.keySet.each do |key_val|
      arr.push(key_val)
    end
    
    return arr
  end
  
  def delete(key_val:Object)
    @hash.remove(key_val)
  end
  
  def delete_keys(keys:Array)
    inst = self
    keys.each do |key_val|
      inst.delete(key_val)
    end
  end
  
  #'has_key' and various aliases.
  def has_key?(key_val:Object)
    return @hash.containsKey(key_val)
  end
  
  def include?(key_val:Object)
    return self.has_key?(key_val)
  end
  
  def member?(key_val:Object)
    return self.has_key?(key_val)
  end
  
  def key?(key_val:Object)
    return self.has_key?(key_val)
  end
  
  #'has_value' and various aliases.
  def has_value?(val:Object)
    return @hash.containsValue(val)
  end
  
  def value?(val:Object)
    return self.has_value?(val)
  end
  
  #'fetch' and various variations.
  def fetch(key_val:Object)
    return @hash.get(key_val)
  end
  
  def fetch(key_val:Object, default:Object)
    if @hash.containsKey(key_val)
      return @hash.get(key_val)
    else
      return default
    end
  end
  
  def [](key_val:Object)
    return self.fetch(key_val)
  end
  
  #Runs a loop for each ke and value.
  def each(blk:HashEachKeyValInterface)
    keyset = @hash.keySet
    hash = @hash
    
    if blk != nil
      keyset.each do |key_i|
        blk.run(key_i, hash.get(key_i))
      end
      
      return nil
    else
      return Enumerator.new do |yielder|
        keyset.each do |key_i|
          yielder.push(Array.new.push(key_i).push(hash.get(key_i)))
        end
      end
    end
  end
  
  #Returns a string representing the hash.
  def to_s
    return @hash.toString
  end
  
  def toString
    return @hash.toString
  end
  
  #Various other methods.
  def keep_if(blk:HashEachKeyValBoolInterface):void
    keys = Array.new
    inst = self
    
    self.each do |key_i, val|
      keys.push(key_i) if !blk.run(key_i, val)
    end
    
    self.delete_keys(keys)
  end
  
  def delete_if(blk:HashEachKeyValBoolInterface):void
    keys = Array.new
    inst = self
    
    self.each do |key_i, val|
      keys.push(key_i) if blk.run(key_i, val)
    end
    
    self.delete_keys(keys)
  end
  
  def merge(o_hash:Hash)
    newhash = Hash.new
    
    self.each do |key_i, val|
      newhash.store(key_i, val)
    end
    
    o_hash.each do |key_i, val|
      newhash.store(key_i, val)
    end
    
    return newhash
  end
  
  def select(blk:HashEachKeyValBoolInterface)
    newhash = Hash.new
    
    self.each do |key_i, val|
      newhash.store(key_i, val) if blk.run(key_i, val)
    end
    
    return newhash
  end
end