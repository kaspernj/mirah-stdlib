package mirah.stdlib

import org.junit.Assert

import mirah.stdlib.test_helpers.TestClass

class TestEnv < TestClass
  def test_env
    Assert.assertEquals(ENV.fetch("_"), System.getenv("_"))
  end
end
