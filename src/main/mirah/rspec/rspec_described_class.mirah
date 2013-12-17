package mirah.stdlib.rspec

import mirah.stdlib.*

class RSpecDescribedClass
  def initialize(clazz:Class)
    @clazz = clazz
    @specs = Array.new
  end
  
  def it(str:String, blk:RSpecItBlock):void
    rspec_test = RSpecTest.new(str, blk)
    @specs.push(rspec_test)
  end
end
