package mirah.stdlib

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
    file = @file
    
    enum = Enumerator.new do |yielder|
      files = file.list
      
      yielder.push(".")
      yielder.push("..")
      
      files.each do |file_str|
        yielder.push(file_str)
      end
    end
    
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