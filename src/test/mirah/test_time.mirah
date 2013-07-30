package mirah.stdlib

import org.junit.Test
import org.junit.Assert

class TestTime
  $Test
  def test_time_returns:void
    time = Time.new
    
    sec = time.sec
    raise "Invalid seconds: #{sec}" if sec < 0 or sec > 59
    
    min = time.min
    raise "Invalid minutes: #{min}" if min < 0 or min > 59
    
    hour = time.hour
    raise "Invalid hours: #{hour}" if hour < 0 or hour > 59
    
    day = time.day
    raise "Invalid day: #{day}" if day <= 0 or day > 31
    
    month = time.month
    raise "Invalid month: #{month}" if month <= 0 or month > 12
    
    year = time.year
    raise "Invalid year: #{year}" if year < 2013 or year > 2099
    
    float_val_as_str = String.valueOf(time.to_f)
    raise "Invalid float: #{float_val_as_str}" if !float_val_as_str.contains(".")
  end
end
