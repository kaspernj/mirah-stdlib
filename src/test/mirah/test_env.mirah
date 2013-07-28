package mirah.stdlib

import org.junit.Test
import org.junit.Assert

$TestClass
class TestEnv
  $Test
  def test_env
    Assert.assertEquals(ENV.fetch("_"), System.getenv("_"))
  end
end
