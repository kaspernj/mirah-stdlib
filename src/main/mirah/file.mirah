package mirah.stdlib

interface OneStringArgBlock do
  def run(str:String):void; end
end

interface OneFileArgBlock do
  def run(fp:File):void; end
end

class File
  def self.directory?(path:String)
    return java::io::File.new(path).isDirectory
  end
  
  def self.file?(path:String)
    return java::io::File.new(path).isFile
  end
  
  def self.exists?(path:String)
    return true if java::io::File.new(path).exists
    return false
  end
  
  def self.exist?(path:String)
    return File.exists?(path)
  end
  
  def exists?
    return File.exists?(@path)
  end
  
  def self.extname(path:String)
    regex_extname = /\.(.+)$/
    match_extname = regex_extname.matcher(path)
    
    if match_extname.find
      ext_found = match_extname.group(0)
      
      #Return empty string if the extension is the same as the entire path.
      return "" if ext_found.equals(path)
      
      #Return the extension found.
      return ext_found
    else
      #Couldnt found extension - default is to return empty string.
      return ""
    end
  end
  
  def initialize(path:String)
    @path = path
    @mode = "r"
    @debug = false
  end
  
  def initialize(path:String, mode:String)
    @path = path
    @mode = "r"
    
    self.validate_mode
  end
  
  def debug(str:String)
    puts str if @debug
  end
  
  def debug_enabled
    return @debug
  end
  
  def self.unlink(path:String):void
    delete(path)
  end
  
  def self.delete(path:String):void
    File.new(path).delete
  end
  
  def delete:void
    java::io::File.new(@path).delete
  end
  
  def unlink:void
    self.delete
  end
  
  def self.basename(path:String)
    return self.basename(path, nil)
  end
  
  def self.basename(path:String, ext:String)
    basename_str = java::io::File.new(path).getName
    
    if ext != nil
      ext_index = basename_str.lastIndexOf(ext)
      
      if ext_index != -1
        basename_str = basename_str.substring(0, ext_index)
      end
    end
    
    return basename_str
  end
  
  def self.dirname(path:String)
    return java::io::File.new(path).getParent
  end
  
  def self.open(path:String, mode:String, blk:OneFileArgBlock = nil)
    file = File.new(path, mode)
    file.validate_mode
    
    if blk != nil
      begin
        blk.run(file)
      ensure
        file.close
      end
    end
    
    return file
  end
  
  def self.read(path:String)
    ret = nil
    File.open(path, "r") do |fp|
      ret = fp.read
    end
    
    return ret
  end
  
  def read
    sb = StringBuffer.new
    
    self.lines do |line|
      sb.append(line)
    end
    
    return sb.toString
  end
  
  def write(str:String)
    @fwriter = java::io::FileWriter.new(@path) if @fwriter == nil
    @fwriter.write(str)
  end
  
  def close
    @fwriter.close if @fwriter != nil
  end
  
  def validate_mode
    raise "Invalid file-mode: '#{@mode}'." if !@mode.equals("w") and !@mode.equals("r")
  end
  
  def lines(sep:String = "\n", blk:OneStringArgBlock = nil):Enumerator
    raise "Not in read mode: '#{@mode}'." if !@mode.equals("r")
    path = @path
    inst = self
    
    debug "Making enumerator."
    enum = Enumerator.new do |yielder|
      inst.debug "Opening streams and readers."
      
      fis = java::io::FileInputStream.new(path)
      dis = java::io::DataInputStream.new(fis)
      isr = java::io::InputStreamReader.new(dis)
      br = java::io::BufferedReader.new(isr)
      fopen = true
      
      while fopen
        inst.debug "Reading line." if inst.debug_enabled
        line_str = ""
        
        while fopen
          char_int = br.read
          if char_int == -1
            fopen = false
            break
          end
          
          line_str += char(char_int)
          break if char_int == 10
        end
        
        inst.debug "Pushing line to yielder." if inst.debug_enabled
        yielder.push(line_str)
      end
      
      br.close
      isr.close
      dis.close
      fis.close
    end
    
    if blk != nil
      debug "Block given - run enumerator through block."
      enum.each do |ele|
        blk.run(String(ele))
      end
      
      return nil
    else
      debug "No block given - return enumerator."
      return enum
    end
  end
  
  def lines(blk:OneStringArgBlock):Enumerator
    return self.lines("\n", blk)
  end
  
  def to_s
    return "<Mirah::File::#{@path}>"
  end
  
  def toString
    return self.to_s
  end
end
