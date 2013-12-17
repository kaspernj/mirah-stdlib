package mirah.stdlib

class Tempfile
  def initialize(name:String):void
    path = "#{Dir.tmpdir}/mirah-stdlib-tempfile-#{name}-#{Time.now.to_i}"
    @file = File.new(path, "w")
    @file.validate_mode
    @file.write("")
  end
  
  def initialize:void
    path = "#{Dir.tmpdir}/mirah-stdlib-tempfile-#{Time.now.to_i}"
    @file = File.new(path, "w")
    @file.validate_mode
    @file.write("")
  end
  
  def finalize:void
    File.unlink(path) if File.exists?(path)
  end
  
  # All these methods are only here, because Mirah doesn't extend classes :-(
  def path; @file.path; end
end
