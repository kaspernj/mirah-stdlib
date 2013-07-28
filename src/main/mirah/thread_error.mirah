package mirah.stdlib

class ThreadError < RuntimeException
  def initialize(str:String)
    super(str)
  end
end
