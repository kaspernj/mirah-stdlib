package mirah.stdlib

class ENV
  def self.fetch(key:String)
    return System.getenv(key)
  end
  
  def self.[](key:String)
    return self.fetch(key)
  end
end
