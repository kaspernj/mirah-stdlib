package mirah.stdlib

class Tempfile < File
  def initialize(name:String)
    @path = "#{Dir.tmpdir}/mirah-stdlib-tempfile-#{name}-#{Time.now.to_i}"
    @mode = "w"
  end
  
  def initialize
    @path = "#{Dir.tmpdir}/mirah-stdlib-tempfile-#{Time.now.to_i}"
    @mode = "w"
  end
  
  def finalize
    puts "Finalize: #{path}"
  end
end
