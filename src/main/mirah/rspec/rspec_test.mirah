package mirah.stdlib.rspec

class RSpecTest
  def initialize(descr:String, blk:RSpecItBlock)
    @descr = descr
    @blk = blk
  end
end
