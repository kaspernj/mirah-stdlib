package mirah.stdlib

import org.junit.Test
import org.junit.Assert

$TestClass
class TestTempfile
  def test_tmpdir:void
    tmpdir = Tempfile.new("foo")
  end
end
