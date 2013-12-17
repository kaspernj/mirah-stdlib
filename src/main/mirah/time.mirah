package mirah.stdlib

import java.text.SimpleDateFormat

class Time
  def self.at(time:int)
    time_obj = Time.new
    time_obj.millis = long(time * 1000)
    return time_obj
  end
  
  def self.now
    Time.new
  end
  
  def initialize
    @millis = System.currentTimeMillis
  end
  
  def millis=(millis:long)
    @millis = millis
  end
  
  def sdf_int(format_str:String)
    return Integer.parseInt(SimpleDateFormat.new(format_str).format(java::util::Date.new(@millis)))
  end
  
  def sec
    return self.sdf_int("ss")
  end
  
  def min
    return self.sdf_int("mm")
  end
  
  def hour
    return self.sdf_int("HH")
  end
  
  def day
    return self.sdf_int("dd")
  end
  
  def mday
    return self.day
  end
  
  def month
    return self.sdf_int("MM")
  end
  
  def mon
    return self.month
  end
  
  def year
    return self.sdf_int("yyyy")
  end
  
  def to_i
    return int(@millis / 1000)
  end
  
  def to_f
    return double(double(@millis) / double(1000))
  end
end