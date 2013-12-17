package mirah.stdlib

import mirah.stdlib.rspec.*

class RSpec
  def self.describe(clazz:Class, blk:RSpecDescribeBlock)
    described_class = RSpecDescribedClass.new(clazz)
    blk.run described_class
  end
end
