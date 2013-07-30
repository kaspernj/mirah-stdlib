package mirah.stdlib

import java.util.ArrayList

interface DirForeachInterface do
  def run(file:String):void; end
end

class Dir
  def self.foreach(path:String, blk:DirForeachInterface)
    dir = Dir.new(path)
    
    begin
      dir.each(blk)
    ensure
      dir.close
    end
  end
  
  def self.exists?(path:String)
    file = java::io::File.new(path)
    return true if file.exists and file.isDirectory
    return false
  end
  
  def self.exist?(path:String)
    return Dir.exists?(path)
  end
  
  def self.mkdir(path:String)
    java::io::File.new(path).mkdir
  end
  
  def self.delete(path:String)
    java::io::File.new(path).delete
  end
  
  def self.unlink(path:String)
    File.delete(path)
  end
  
  def self.rmdir(path:String)
    File.delete(path)
  end
  
  def initialize(path:String)
    @file = java::io::File.new(path)
  end
  
  def each(blk:DirForeachInterface)
    list = @file.list
    
    arr = ArrayList.new(list.length + 2)
    arr.add(".")
    arr.add("..")
    
    list.each do |file_i|
      arr.add(file_i)
    end
    
    enum = Enumerator.new(arr)
    
    if blk != nil
      enum.each do |file_str|
        blk.run(String(file_str))
      end
      
      return nil
    else
      return enum
    end
  end
  
  #Does nothing yet...
  def close
    
  end
end
